# db/seeds.rb

Faker::Config.locale = :fr

USER_COUNT  = 15
EVENT_COUNT = 8
MAX_GUESTS  = 10

puts "Reset..."
Attendance.delete_all
Event.delete_all
User.delete_all

def rounded_duration
  # Return a multiple of 5 between 5 and 30 minutes
  [1, 2, 3, 4, 5, 6].sample * 5
end

def valid_description
  Faker::Lorem.paragraph_by_chars(number: rand(80..300), supplemental: false)
end

puts "Users..."
users = USER_COUNT.times.map do |i|
  User.create!(
    email: "user#{i}@yopmail.com",
    encrypted_password: "changeme",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: Faker::Lorem.sentence(word_count: 10)
  )
end

puts "Events..."
events = EVENT_COUNT.times.map do
  organizer = users.sample
  Event.create!(
    start_date: Faker::Time.forward(days: rand(1..20), period: :evening),
    duration: rounded_duration,
    title: Faker::Lorem.sentence(word_count: rand(2..8)).first(140),
    description: valid_description,
    price: rand(1..1000),
    location: "#{Faker::Address.city}, #{Faker::Address.country}",
    organizer: organizer
  )
end

puts "Attendances..."
events.each do |event|
  attendees = users.reject { |user| user == event.organizer }
  attendee_count = rand(0..MAX_GUESTS)
  attendees.sample(attendee_count).each do |attendee|
    Attendance.create!(user: attendee, event: event)
  end
end

puts "Done."
