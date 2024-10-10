module Mutations
    class DeleteQuestion < Mutations::BaseMutation
      argument :id, ID, required: true
  
      field :question, Types::QuestionType, null: false
      field :errors, [String], null: false
  
      def resolve(id:)
        question = Question.find(id)
        if question.destroy
          { question: question, errors: [] }
        else
          { question: nil, errors: question.errors.full_messages }
        end
      rescue ActiveRecord::RecordNotFound
        { question: nil, errors: ["Question not found"] }
      end
    end
  end
  