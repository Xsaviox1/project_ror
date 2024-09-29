class CreateSurveys < ActiveRecord::Migration[7.2]
  def change
    create_table :surveys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :titulo
      t.integer :amt_questions
      t.string :status

      t.timestamps
    end
  end
end
