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

      unless user.role == 'player'
        raise GraphQL::ExecutionError, "Only players are able to answer the questions"
      end
      

      question = Question.find_by(id: question_id)
      raise GraphQL::ExecutionError, "Question not found" unless question

      case question.question_type
      when 'multiple'
        valid_options = question.options.pluck(:content)
        unless valid_options.include?(content)
          raise GraphQL::ExecutionError, "The answer must be one of the options: #{valid_options.join(', ')}"
        end

      when 'unique'
        valid_options = question.options.pluck(:content)
        unless valid_options.include?(content)
          raise GraphQL::ExecutionError, "The answer must be one of the options: #{valid_options.join(', ')}"
        end
        if content.is_a?(Array)
          if content.size > 1
            raise GraphQL::ExecutionError, "You can only choose one option."
          end
          content = content.first
        end

      when 'short'
        if content.length > 100
          raise GraphQL::ExecutionError, "Responses of type 'short' cannot exceed 100 characters."
        end

      when 'long'
        if content.length > 10000
          raise GraphQL::ExecutionError, "Responses of type 'long' cannot exceed 10000 characters."
        end

      else
        raise GraphQL::ExecutionError, "Tipo de pergunta inválido: #{question.question_type}."
      end

      response = question.responses.create!(content: content)

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
