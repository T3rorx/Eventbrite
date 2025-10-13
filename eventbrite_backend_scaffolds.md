# Eventbrite Rails — Backend BDD & Scaffolds

> Résumé prêt à l’emploi pour générer la BDD, poser les associations et validations.

---

## 1) Générateurs

```bash
# Users (Devise demain, table aujourd’hui)
rails g scaffold User \
  email:string{default:""} encrypted_password:string{default:""} \
  first_name:string last_name:string description:text

# Events (user = organisateur)
rails g scaffold Event \
  start_date:datetime duration:integer title:string description:text \
  price:integer location:string user:references

# Attendances (table de jointure + Stripe)
rails g scaffold Attendance \
  user:references event:references stripe_customer_id:string
```

---

## 2) Ajustements migrations

### `db/migrate/*_create_users.rb`
```rb
t.string :email,              null: false, default: ""
t.string :encrypted_password, null: false, default: ""
add_index :users, :email
```

### `db/migrate/*_create_events.rb`
```rb
add_index :events, :user_id
```

### `db/migrate/*_create_attendances.rb`
```rb
add_index :attendances, [:user_id, :event_id], unique: true
add_index :attendances, :stripe_customer_id
```

> Optionnel PostgreSQL (checks côté DB) à placer dans une migration ultérieure :
```rb
def up
  execute <<~SQL
    ALTER TABLE events
      ADD CONSTRAINT events_price_chk CHECK (price BETWEEN 1 AND 1000),
      ADD CONSTRAINT events_duration_pos_chk CHECK (duration > 0),
      ADD CONSTRAINT events_duration_step5_chk CHECK (mod(duration, 5) = 0),
      ADD CONSTRAINT events_title_len_chk CHECK (char_length(title) BETWEEN 5 AND 140),
      ADD CONSTRAINT events_desc_len_chk CHECK (char_length(description) BETWEEN 20 AND 1000);
  SQL
end
def down
  execute <<~SQL
    ALTER TABLE events
      DROP CONSTRAINT events_price_chk,
      DROP CONSTRAINT events_duration_pos_chk,
      DROP CONSTRAINT events_duration_step5_chk,
      DROP CONSTRAINT events_title_len_chk,
      DROP CONSTRAINT events_desc_len_chk;
  SQL
end
```

---

## 3) Modèles

### `app/models/user.rb`
```rb
class User < ApplicationRecord
  has_many :organized_events, class_name: "Event", foreign_key: :user_id,
           dependent: :restrict_with_exception
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances

  validates :email, presence: true
  validates :encrypted_password, presence: true
end
```

### `app/models/event.rb`
```rb
class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :user_id
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user

  validates :start_date, presence: true
  validate  :start_date_not_in_past
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate  :duration_multiple_of_5
  validates :title, presence: true, length: { minimum: 5, maximum: 140 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :location, presence: true

  private

  def start_date_not_in_past
    errors.add(:start_date, "ne peut pas être dans le passé") if start_date.present? && start_date < Time.current
  end

  def duration_multiple_of_5
    return unless duration.present?
    errors.add(:duration, "doit être un multiple de 5") unless duration % 5 == 0
  end
end
```

### `app/models/attendance.rb`
```rb
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :stripe_customer_id, presence: true
  validates :user_id, uniqueness: { scope: :event_id }
end
```

---

## 4) Routes minimales
```rb
Rails.application.routes.draw do
  resources :users
  resources :events
  resources :attendances
end
```

---

## 5) Seed rapide

`db/seeds.rb`
```rb
10.times do |i|
  User.create!(
    email: "user#{i}@yopmail.com",
    encrypted_password: "changeme",
    first_name: "User#{i}",
    last_name: "Yop",
    description: "Profil ##{i}"
  )
end

organizer = User.first
e = Event.create!(
  start_date: 1.day.from_now,
  duration: 60,
  title: "Rails Meetup",
  description: "Atelier Rails et BDD, 1h de code ensemble.",
  price: 10,
  location: "Grenoble",
  user_id: organizer.id
)

User.where.not(id: organizer.id).first(3).each_with_index do |u, idx|
  Attendance.create!(user: u, event: e, stripe_customer_id: "cus_test_#{idx}")
end
```

Exécuter :
```bash
rails db:migrate
rails db:seed
```

---

## 6) DBML de référence (optionnel)
```dbml
Table users {
  id integer [pk, increment]
  email varchar(255) [not null, default: ""]
  encrypted_password varchar(255) [not null, default: ""]
  first_name varchar(255)
  last_name varchar(255)
  description text
  created_at timestamp
}

Table events {
  id integer [pk, increment]
  start_date timestamptz [not null]
  duration integer [not null]
  title varchar(140) [not null]
  description text [not null]
  price integer [not null]
  location varchar(255) [not null]
  user_id integer [not null]
  created_at timestamp
  Indexes {
    user_id
  }
}

Table attendances {
  id integer [pk, increment]
  user_id integer [not null]
  event_id integer [not null]
  stripe_customer_id varchar(255) [not null]
  created_at timestamp
  Indexes {
    (user_id, event_id) [unique]
  }
}

Ref: events.user_id > users.id
Ref: attendances.user_id > users.id
Ref: attendances.event_id > events.id
```
