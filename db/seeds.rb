# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

puts('Creating 10 users')
User.create!(name: "Nietzsche",       personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/1', expertise: ['black', 'white', 'good', 'evil', 'power'] )
User.create!(name: "Heidegger",       personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/2', expertise: ['good', 'evil', 'time'] )
User.create!(name: "Beavoir",         personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/3', expertise: ['love', 'black', 'white', 'feminism'] )
User.create!(name: "Kant",            personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/4', expertise: ['good', 'epistemology'] )
User.create!(name: "Hegel",           personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/5', expertise: ['feminism', 'black', 'white'] )
User.create!(name: "Foucault",        personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/6', expertise: ['feminism', 'epistemology'] )
User.create!(name: "Marx",            personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/7', expertise: ['workers', 'black', 'white'] )
User.create!(name: "Singer",          personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/8', expertise: ['good', 'evil', 'feminism', 'animals'] )
User.create!(name: "Nietzsche again", personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/9', expertise: ['nihilism'] )
User.create!(name: "Laplace",         personal_website: 'http://www.hackmd.io', shortened_website: 'www.pbs.com/10', expertise: ['determinism', 'math', 'science', 'black', 'white'] )

puts('Creating friendship map')
Friendship.create!(user_id:1,  friend_id:2)
Friendship.create!(user_id:8,  friend_id:6)
Friendship.create!(user_id:8,  friend_id:3)
Friendship.create!(user_id:1,  friend_id:3)
Friendship.create!(user_id:4,  friend_id:10)
Friendship.create!(user_id:10, friend_id:6)
Friendship.create!(user_id:2,  friend_id:5)
Friendship.create!(user_id:4,  friend_id:2)
Friendship.create!(user_id:7,  friend_id:1)
Friendship.create!(user_id:7,  friend_id:5)
Friendship.create!(user_id:7,  friend_id:9)

