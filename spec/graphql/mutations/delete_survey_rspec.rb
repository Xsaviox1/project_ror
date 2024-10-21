require 'rails_helper'

RSpec.describe "mutation delete_survey", type: :request do
  let!(:user_admin) { User.create!(name: "Sávio110", password: "password123", role: "admin") }
  let!(:user_player) { User.create!(name: "SávioPlayer", password: "password123", role: "player") }
  let!(:survey) { Survey.create!(title: "Survey Title", user: user_admin, amt_questions: 2) }

  it "allows admin to delete a survey" do
    token = JWT.encode({ user_id: user_admin.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
      mutation {
        deleteSurvey(input: {
          id: #{survey.id}
        }) {
          survey {
            id
            title
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['data']['deleteSurvey']['errors']).to be_empty
    expect(json_response['data']['deleteSurvey']['survey']['id']).to eq("#{survey.id}")
    expect(json_response['data']['deleteSurvey']['survey']['title']).to eq("Survey Title")
    expect(Survey.find_by(id: survey.id)).to be_nil
  end

  it "prevents player from deleting a survey" do
    token = JWT.encode({ user_id: user_player.id }, 'segredo', 'HS256')

    query = <<~GQL
      mutation {
        deleteSurvey(input: {
          id: #{survey.id}
        }) {
          survey {
            id
            title
          }
          errors
        }
      }
    GQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)
    expect(json_response['errors'][0]['message']).to eq("Only admins are able to delete surveys")
  end

  it "returns an error when the survey doesn't exist" do
    token = JWT.encode({ user_id: user_admin.id }, 'segredo', 'HS256')

    query = <<~GQL
      mutation {
        deleteSurvey(input: {
          id: 10000 
        }) {
          survey {
            id
            title
          }
          errors
        }
      }
    GQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['data']['deleteSurvey']['survey']).to be_nil
    expect(json_response['data']['deleteSurvey']['errors']).to include("Survey not found")
  end
end
