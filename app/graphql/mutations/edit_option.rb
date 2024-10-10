module Mutations
    class EditQuestion < Mutations::BaseMutation
      argument :id, ID, required: true
      argument :content, String, required: false
      argument :question_type, String, required: false
      argument :amt_options, Integer, required: false
  
      field :question, Types::QuestionType, null: false
      field :errors, [String], null: false
  
      def resolve(id:, content: nil, question_type: nil, amt_options: nil)
        question = Question.find(id)
  
        if question.update(content: content, question_type: question_type, amt_options: amt_options)
          { question: question, errors: [] }
        else
          { question: nil, errors: question.errors.full_messages }
        end
      rescue ActiveRecord::RecordNotFound
        { question: nil, errors: ["Question not found"] }
      end
    end
  end
  