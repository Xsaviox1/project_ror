# db/seeds.rb

# Clear the old database
Response.destroy_all
Option.destroy_all
Question.destroy_all
Survey.destroy_all
User.destroy_all

# Create the tables
admin_user = User.create!(name: "Sávio11", password: "password123", role: "admin")
player_user = User.create!(name: "player", password: "player", role: "player")

survey1 = Survey.create!(title: "Survey 1", user: admin_user, amt_questions: 3)
survey2 = Survey.create!(title: "Survey 2", user: player_user, amt_questions: 2)

question1_survey1 = Question.create!(content: "What is your favorite programming language?", survey: survey1, question_type: "multiple")
question2_survey1 = Question.create!(content: "Do you prefer frontend or backend?", survey: survey1, question_type: "unique")

Option.create!(content: "Ruby", question: question1_survey1)
Option.create!(content: "JavaScript", question: question1_survey1)
Option.create!(content: "Python", question: question1_survey1)

Option.create!(content: "Frontend", question: question2_survey1)
Option.create!(content: "Backend", question: question2_survey1)

question1_survey2 = Question.create!(content: "Which operating system do you use?", survey: survey2, question_type: "multiple")
question2_survey2 = Question.create!(content: "How many hours do you code per day?", survey: survey2, question_type: "unique")

Option.create!(content: "Linux", question: question1_survey2)
Option.create!(content: "Windows", question: question1_survey2)
Option.create!(content: "macOS", question: question1_survey2)

Option.create!(content: "1-2 hours", question: question2_survey2)
Option.create!(content: "3-4 hours", question: question2_survey2)
Option.create!(content: "5+ hours", question: question2_survey2)

puts "Banco de dados populado com sucesso!"
