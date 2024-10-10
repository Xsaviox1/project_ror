class CreateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :titulo
      t.string :content

      t.timestamps
    end
  end
end
