# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject

    field :create_user, mutation: Mutations::CreateUser
    
    field :login, mutation: Mutations::Login

    field :create_survey, mutation: Mutations::CreateSurvey

    field :answer_question, mutation: Mutations::AnswerQuestion
  end
end
