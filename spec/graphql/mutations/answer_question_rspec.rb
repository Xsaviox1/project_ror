require "rails_helper"

RSpec.describe "mutation answer_question", type: :request do
  let!(:admin_user) { User.create!(name: "Sávio110", password: "password123", role: "admin") }
  let!(:player_user) { User.create!(name: "player1", password: "player", role: "player") }
  let!(:survey) { Survey.create!(title: "Survey Title", user: admin_user, amt_questions: 2) }
  let!(:question) { Question.create!(content: "What is your favorite color?", survey: survey, question_type: "multiple") }
  let!(:option1) { Option.create!(content: "Red", question: question) }
  let!(:option2) { Option.create!(content: "Blue", question: question) }

  it "allows a player to answer a question" do
    token = JWT.encode({ user_id: player_user.id }, 'segredo', 'HS256')

    mutation_query = <<~GRAPHQL
      mutation {
        answerQuestion(input: {
          questionId: #{question.id},
          content: "Red"
        }) {
          response {
            id
            content
          }
          question {
            id
            content
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: mutation_query }

    
  end

  it "does not allow an admin to answer a question" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    mutation_query = <<~GRAPHQL
      mutation {
        answerQuestion(input: {
          questionId: #{question.id},
          content: "Red"
        }) {
          response {
            id
            content
          }
          question {
            id
            content
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: mutation_query }

    json_response = JSON.parse(response.body)

    expect(json_response['errors']).not_to be_nil
    expect(json_response['errors'][0]['message']).to eq("Only players are able to answer the questions")
  end
end
