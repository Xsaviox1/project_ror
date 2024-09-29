class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :content
      t.string :type

      t.timestamps
    end
  end
end
