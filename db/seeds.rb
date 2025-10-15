# db/seeds.rb - Grenoble Roller Community

Faker::Config.locale = :fr

puts "🛑 Reset des données..."
Attendance.delete_all
Event.delete_all
User.delete_all

puts "👥 Création des utilisateurs Grenoblois..."

# Utilisateurs réalistes avec des profils variés
users_data = [
  {
    email: "marie.dubois@free.fr",
    first_name: "Marie",
    last_name: "Dubois",
    description: "Passionnée de roller depuis 5 ans, j'organise des sorties dans le centre-ville de Grenoble. Toujours partante pour découvrir de nouveaux spots !"
  },
  {
    email: "thomas.martin@gmail.com",
    first_name: "Thomas",
    last_name: "Martin",
    description: "Instructeur de roller freestyle, spécialisé dans les figures techniques. Cours pour débutants et confirmés dans le parc Paul Mistral."
  },
  {
    email: "sophie.bernard@orange.fr",
    first_name: "Sophie",
    last_name: "Bernard",
    description: "Roller de vitesse sur la piste cyclable de l'Isère. J'adore les longues distances et organiser des randonnées roller."
  },
  {
    email: "julien.rousseau@hotmail.com",
    first_name: "Julien",
    last_name: "Rousseau",
    description: "Roller hockey amateur, membre de l'équipe Grenoble Roller Hockey. Entraînements au gymnase du campus."
  },
  {
    email: "laura.moreau@yahoo.fr",
    first_name: "Laura",
    last_name: "Moreau",
    description: "Roller artistique et danse. Je donne des cours au centre-ville et organise des spectacles lors des événements grenoblois."
  },
  {
    email: "pierre.lemoine@wanadoo.fr",
    first_name: "Pierre",
    last_name: "Lemoine",
    description: "Roller urbain et freestyle. Expert des spots de Grenoble, j'organise des sessions dans les différents quartiers."
  },
  {
    email: "camille.durand@laposte.net",
    first_name: "Camille",
    last_name: "Durand",
    description: "Roller de loisir et tourisme. J'aime faire découvrir Grenoble en roller, de la Bastille au parc Mistral."
  },
  {
    email: "antoine.petit@sfr.fr",
    first_name: "Antoine",
    last_name: "Petit",
    description: "Roller de descente et vitesse. Spécialiste des routes de montagne autour de Grenoble. Casque obligatoire !"
  },
  {
    email: "emilie.richard@gmail.com",
    first_name: "Émilie",
    last_name: "Richard",
    description: "Roller fitness et bien-être. Cours de roller pour seniors et débutants dans les parcs de Grenoble."
  },
  {
    email: "nicolas.blanc@free.fr",
    first_name: "Nicolas",
    last_name: "Blanc",
    description: "Roller cross-training et endurance. Entraînements intensifs pour préparer les compétitions régionales."
  },
  {
    email: "claire.garcia@orange.fr",
    first_name: "Claire",
    last_name: "Garcia",
    description: "Roller de nuit et urbain. Organisatrice des sorties nocturnes illuminées dans les rues de Grenoble."
  },
  {
    email: "romain.fournier@hotmail.com",
    first_name: "Romain",
    last_name: "Fournier",
    description: "Roller technique et slalom. Champion régional, je partage mes techniques avec la communauté grenobloise."
  }
]

# Créer d'abord le compte admin
admin_user = User.create!(
  email: "user0@yopmail.com",
  password: "Admin",
  password_confirmation: "Admin",
  first_name: "Admin",
  last_name: "Grenoble",
  description: "Administrateur de la plateforme Grenoble Roller. Gestion de la communauté et organisation des événements."
)

users = users_data.map do |user_data|
  User.create!(
    email: user_data[:email],
    password: "password123",
    password_confirmation: "password123",
    first_name: user_data[:first_name],
    last_name: user_data[:last_name],
    description: user_data[:description]
  )
end

# Ajouter l'admin à la liste des utilisateurs
users << admin_user

puts "🎯 Création des événements Grenoblois..."

# Lieux emblématiques de Grenoble pour le roller
grenoble_locations = [
  "Parc Paul Mistral, Grenoble",
  "Place Grenette, Grenoble",
  "Quai de l'Isère, Grenoble",
  "Parc de la Bastille, Grenoble",
  "Campus universitaire, Saint-Martin-d'Hères",
  "Place Victor Hugo, Grenoble",
  "Parc Jean Verlhac, Grenoble",
  "Gare de Grenoble, Grenoble",
  "Place Notre-Dame, Grenoble",
  "Parc des Champs-Élysées, Grenoble",
  "Place aux Herbes, Grenoble",
  "Parc de l'Île Verte, Grenoble",
  "Place de Verdun, Grenoble",
  "Parc de la Poya, Fontaine",
  "Centre-ville de Grenoble"
]

# Types d'événements roller typiques
event_templates = [
  {
    title: "Sortie roller nocturne illuminée",
    description: "Sortie roller de nuit avec LED et musique dans les rues de Grenoble. Parcours sécurisé avec accompagnateurs. Éclairage et casque fournis.",
    duration: 120,
    price: 0
  },
  {
    title: "Randonnée roller le long de l'Isère",
    description: "Belle randonnée roller le long des quais de l'Isère jusqu'au parc Paul Mistral. Niveau débutant à intermédiaire. Pause pique-nique prévue.",
    duration: 180,
    price: 5
  },
  {
    title: "Cours de roller freestyle - Débutants",
    description: "Apprentissage des bases du roller freestyle : équilibre, virages, freinage. Matériel fourni. Cours dans le parc Paul Mistral.",
    duration: 90,
    price: 15
  },
  {
    title: "Session roller hockey",
    description: "Match amical de roller hockey au gymnase du campus. Ouvert à tous les niveaux. Matériel de protection fourni.",
    duration: 120,
    price: 8
  },
  {
    title: "Roller fitness en musique",
    description: "Séance de roller fitness avec musique entraînante. Exercices cardio et renforcement musculaire. Parfait pour se remettre en forme !",
    duration: 60,
    price: 12
  },
  {
    title: "Sortie roller urbaine - Centre-ville",
    description: "Découverte de Grenoble en roller : monuments, places, parcs. Visite guidée avec explications historiques. Niveau débutant.",
    duration: 150,
    price: 10
  },
  {
    title: "Compétition roller de vitesse",
    description: "Course de vitesse sur piste cyclable. Catégories : débutant, intermédiaire, expert. Trophées pour les 3 premiers de chaque catégorie.",
    duration: 240,
    price: 20
  },
  {
    title: "Roller artistique et danse",
    description: "Atelier de roller artistique et danse. Apprentissage de chorégraphies et figures élégantes. Spectacle de fin de session.",
    duration: 120,
    price: 18
  },
  {
    title: "Sortie roller de montagne",
    description: "Descente en roller sur les routes de montagne autour de Grenoble. Casque et protections obligatoires. Niveau confirmé uniquement.",
    duration: 300,
    price: 25
  },
  {
    title: "Roller pour seniors",
    description: "Cours de roller adapté aux seniors. Exercices doux et sécurisés. Parfait pour maintenir l'équilibre et la forme.",
    duration: 60,
    price: 8
  },
  {
    title: "Session slalom et technique",
    description: "Perfectionnement des techniques de roller : slalom, virages serrés, freinage d'urgence. Matériel technique fourni.",
    duration: 90,
    price: 15
  },
  {
    title: "Roller cross-training",
    description: "Entraînement intensif combinant roller, musculation et cardio. Pour préparer les compétitions ou améliorer ses performances.",
    duration: 120,
    price: 20
  }
]

events = []

# Créer des événements avec des dates réalistes
event_templates.each_with_index do |template, index|
  organizer = users.sample
  location = grenoble_locations.sample
  
  # Dates variées : certains dans le passé récent, d'autres dans le futur
  if index < 4
    # Événements passés récents
    start_date = rand(7.days.ago..2.days.ago)
  elsif index < 8
    # Événements futurs proches
    start_date = rand(1.day.from_now..14.days.from_now)
  else
    # Événements futurs plus lointains
    start_date = rand(15.days.from_now..30.days.from_now)
  end
  
  # Heures réalistes selon le type d'événement
  if template[:title].include?("nocturne") || template[:title].include?("nuit")
    start_date = start_date.change(hour: 20, min: 0)
  elsif template[:title].include?("seniors")
    start_date = start_date.change(hour: 10, min: 0)
  elsif template[:title].include?("randonnée") || template[:title].include?("sortie")
    start_date = start_date.change(hour: 14, min: 30)
  else
    start_date = start_date.change(hour: [18, 19, 20].sample, min: [0, 30].sample)
  end
  
  event = Event.create!(
    start_date: start_date,
    duration: template[:duration],
    title: template[:title],
    description: template[:description],
    price: template[:price],
    location: location,
    organizer: organizer
  )
  
  events << event
end

puts "🎫 Création des inscriptions aux événements..."

# Créer des inscriptions réalistes
events.each do |event|
  # Ne pas inscrire l'organisateur à son propre événement
  available_users = users - [event.organizer]
  
  # Nombre d'inscrits variable selon le type d'événement
  if event.title.include?("compétition") || event.title.include?("cross-training")
    attendee_count = rand(8..15) # Événements spécialisés
  elsif event.title.include?("débutants") || event.title.include?("seniors")
    attendee_count = rand(6..12) # Cours structurés
  elsif event.price == 0
    attendee_count = rand(15..25) # Événements gratuits populaires
  else
    attendee_count = rand(5..18) # Événements payants
  end
  
  # Inscrire des utilisateurs
  selected_attendees = available_users.sample([attendee_count, available_users.length].min)
  
  selected_attendees.each do |attendee|
    Attendance.create!(user: attendee, event: event)
  end
  
  puts "  ✅ #{event.title} : #{selected_attendees.length} inscrits"
end

puts "🎉 Seed terminée !"
puts "📊 Statistiques :"
puts "  👥 Utilisateurs : #{User.count}"
puts "  🎯 Événements : #{Event.count}"
puts "  🎫 Inscriptions : #{Attendance.count}"
puts "  📍 Lieux : #{events.map(&:location).uniq.count} lieux différents"
puts ""
puts "🚀 Prêt à découvrir la communauté roller grenobloise !"
