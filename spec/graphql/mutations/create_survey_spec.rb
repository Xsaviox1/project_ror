require "rails_helper"

RSpec.describe "mutation create_survey", type: :request do
  let!(:admin_user) { User.create!(name: "Sávio12", password: "password123", role: "admin") }
  let!(:player_user) { User.create!(name: "PlayerUser", password: "password123", role: "player") }

  it "creates the survey" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
      mutation {
        createSurvey(input: {
          name: "Sávio12",
          title: "Survey Title",
          amtQuestions: 3,
          contents: [
            "What is your favorite color?",
            "What is your favorite food?",
            "What is your favorite hobby?"
          ],
          questionTypes: ["multiple", "unique", "short"],
          options: [["Red", "Blue", "Green", "Pink", "Gray"], ["Pizza", "Sushi"], []],
          amtOptions: [3, 2, 0]
        }) {
          user {
            name
          }
          survey {
            id
            title
            amtQuestions
          }
          questions {
            id
            content
            questionType
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['data']['createSurvey']).not_to be_nil
    expect(json_response['data']['createSurvey']['survey']['title']).to eq("Survey Title")
  end

  it "prevents a player from creating a survey" do
    
  
    query = <<~GRAPHQL
      mutation {
        createSurvey(input: {
          name: "PlayerUser",
          title: "Survey Title",
          amtQuestions: 3,
          contents: [
            "What is your favorite color?",
            "What is your favorite food?",
            "What is your favorite hobby?"
          ],
          questionTypes: ["multiple", "unique", "short"],
          options: [["Red", "Blue", "Green"], ["Pizza"], []],
          amtOptions: [3, 1, 0]
        }) {
          user {
            name
          }
          survey {
            id
            title
            amtQuestions
          }
          questions {
            id
            content
            questionType
          }
          errors
        }
      }
    GRAPHQL
  
    post '/graphql',  params: { query: query }
  
    json_response = JSON.parse(response.body)
  
    expect(json_response['data']['createSurvey']).to be_nil
    expect(json_response['errors']).not_to be_nil
  end
  
  

  it "returns an error when required fields are missing" do
    token = JWT.encode({ user_id: admin_user.id }, 'segredo', 'HS256')

    query = <<~GRAPHQL
      mutation {
        createSurvey(input: {
          name: "Sávio12",
          title: null,
          amtQuestions: 3,
          contents: [
            "What is your favorite color?",
            "What is your favorite food?",
            "What is your favorite hobby?"
          ],
          questionTypes: ["multiple", "unique", "short"],
          options: [["Red", "Blue", "Green", "Pink", "Gray"], ["Pizza", "Sushi"], []],
          amtOptions: [3, 2, 0]
        }) {
          user {
            name
          }
          survey {
            id
            title
            amtQuestions
          }
          questions {
            id
            content
            questionType
          }
          errors
        }
      }
    GRAPHQL

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: query }

    json_response = JSON.parse(response.body)

    expect(json_response['errors']).not_to be_nil
  end
end
