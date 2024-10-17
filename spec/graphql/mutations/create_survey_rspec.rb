require "rails_helper"

RSpec.describe "mutation create_survey", type: :request do
  let!(:user) { User.create!(name: "Sávio12", password: "password123", role: "admin") }

  it "creates the survey" do
    expect(User.find_by(name: "Sávio12")).not_to be_nil
    
    token = JWT.encode({ user_id: user.id }, 'segredo', 'HS256')
    expect(token).not_to be_nil
    expect(token).to be_a(String)

    mutation_query = <<~GRAPHQL
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

    post '/graphql', headers: { 'Authorization': "Bearer #{token}" }, params: { query: mutation_query }

    
    json_response = JSON.parse(response.body)


    expect(json_response['data']['createSurvey']).not_to be_nil
    expect(json_response['data']['createSurvey']['survey']['title']).to eq("Survey Title")
  end
end
