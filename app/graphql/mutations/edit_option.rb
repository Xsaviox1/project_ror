module Mutations
    class Mutations::EditOption < Mutations::BaseMutation
      argument :id, ID, required: true
      argument :content, String, required: false
  
      field :question, Types::QuestionType, null: false
      field :errors, [String], null: false
  
      def resolve(id:, content: nil)
        question = Question.find(id)
  
        if question.update(content: content)
          { question: question, errors: [] }
        else
          { question: nil, errors: question.errors.full_messages }
        end
      rescue ActiveRecord::RecordNotFound
        { question: nil, errors: ["Question not found"] }
      end
    end
  end
  