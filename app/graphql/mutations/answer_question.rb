module Mutations
    class AnswerQuestion < Mutations::BaseMutation
  
      argument :question_id, ID, required: true
      argument :content, String, required: true
  
      field :response, Types::ResponseType, null: false  
      field :question, Types::QuestionType, null: false  
      field :errors, [String], null: true
  
      def resolve(content:, question_id:)
       
        user = context[:current_user]
        raise GraphQL::ExecutionError, "User not authenticated" unless user
  
       
        question = Question.find_by(id: question_id)
        raise GraphQL::ExecutionError, "Question not found" unless question
  
       
        response = question.responses.create!(content: content, user: user)
  
        
        {
          response: response,
          question: question,
          errors: []
        }
      rescue ActiveRecord::RecordInvalid => e
        { response: nil, question: nil, errors: [e.message] }
      end
    end
  end