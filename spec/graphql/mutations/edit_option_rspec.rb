require 'rails_helper'

RSpec.describe "mutation edit_option", type: :request do
  let!(:admin_user) { User.create!(name: "Sávio110", password: "password123", role: "admin") }
  let!(:player_user) { User.create!(name: "player1", password: "player", role: "player") }
  let!(:survey) { Survey.create!(title: "Survey Title", user: admin_user, amt_questions: 2) }
  let!(:question) { Question.create!(content: "What is your favorite color?", survey: survey, question_type: "multiple") }
  let!(:option1) { Option.create!(content: "Red", question: question) }
  let!(:option2) { Option.create!(content: "Blue", question: question) }

  it "edits the option successfully" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
    mutation {
      editOption(input: {
        id: #{option1.id},           
        content: "Green"  # Mudei para um novo conteúdo para testar a edição
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
    expect(json_response['data']['editOption']['option']['id']).to eq("#{option1.id}")
    expect(json_response['data']['editOption']['option']['content']).to eq("Green")
  end

  it "prevents player from editing the option" do
    token = JWT.encode({ user_id: player_user.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
    mutation {
      editOption(input: {
        id: #{option1.id},           
        content: "Green"
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

    expect(json_response['errors']).not_to be_nil
    expect(json_response['errors'][0]['message']).to eq("Only admins are able to edit options")
  end

  it "returns an error for a non-existent option" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    query = <<~GQL
    mutation {
      editOption(input: {
        id: 2000,           
        content: "Red"
      }) {
        option {
          id
          content
        }
        errors
      }
    }
    GQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['errors'][0]['message']).to eq("Cannot return null for non-nullable field EditOptionPayload.option")
    expect(json_response['data']['editOption']).to be_nil
  end
end
