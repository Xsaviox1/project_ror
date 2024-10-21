require 'rails_helper'

RSpec.describe "mutation edit_survey", type: :request do
    let!(:user_admin) { User.create!(name: "Sávio110", password: "password123", role: "admin") }
    let!(:user_player) { User.create!(name: "SávioPlayer", password: "password123", role: "player") }
    let!(:survey) { Survey.create!(title: "Survey Title", user: user_admin, amt_questions: 2) }  # Corrigido para user_admin

    it "prevents player from editing the survey" do
        token = JWT.encode({ user_id: user_player.id }, 'segredo', 'HS256')

        query = <<~GRAPHQL
        mutation {
            editSurvey(input: {
                id: #{survey.id},           
                title: "New Title", 
                status: "inactive"    
            }) {
                survey {
                    id
                    title
                    status
                }
                errors
            }
        }
        GRAPHQL

        post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to be_nil
        expect(json_response['data']['editSurvey']['survey']['title']).to eq("New Title")
        expect(json_response['data']['editSurvey']['survey']['status']).to eq("inactive")
    end

    it "allows admin to edit the survey" do
        token = JWT.encode({ user_id: user_admin.id }, 'segredo', 'HS256')

        query = <<~GRAPHQL
        mutation {
            editSurvey(input: {
                id: #{survey.id},           
                title: "New Title", 
                status: "inactive"    
            }) {
                survey {
                    id
                    title
                    status
                }
                errors
            }
        }
        GRAPHQL

        post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

        json_response = JSON.parse(response.body)

        expect(json_response['errors']).not_to be_nil
        expect(json_response['errors'][0]['message']).to eq("Only players are able to answer the questions")
    end
end
