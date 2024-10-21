require 'rails_helper'

RSpec.describe "mutation delete_option", type: :request do
  let!(:admin_user) { User.create!(name: "Sávio110", password: "password123", role: "admin") }
  let!(:player_user) { User.create!(name: "player1", password: "player", role: "player") }
  let!(:survey) { Survey.create!(title: "Survey Title", user: admin_user, amt_questions: 2) }
  let!(:question) { Question.create!(content: "What is your favorite color?", survey: survey, question_type: "multiple", amt_options: 2) }
  let!(:option1) { Option.create!(content: "Red", question: question) }
  let!(:option2) { Option.create!(content: "Blue", question: question) }

  it "deletes the selected option" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')
    query = <<~GRAPHQL
      mutation {
        deleteOption(input: {
          id: #{option1.id}
        }) {
          option {
            id
            content
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)
    
    expect(json_response['errors']).to be_nil
    expect(json_response['data']['deleteOption']['option']['id']).to eq(option1.id.to_s)
    expect(json_response['data']['deleteOption']['option']['content']).to eq(option1.content)
    expect(Option.find_by(id: option1.id)).to be_nil
    expect(Question.find_by(id: question.id).amt_options).to eq(1)
  end

  it "returns an error when trying to delete with a wrong id" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
      mutation {
        deleteOption(input: {
          id: 99999
        }) {
          option {
            id
            content
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['data']['deleteOption']['option']).to be_nil
    expect(json_response['data']['deleteOption']['errors']).to include("Option not found")
  end
end
