class ChangeResponseAssociation < ActiveRecord::Migration[7.2]
  def change
    remove_reference :responses, :user, foreign_key: true

    add_reference :responses, :question, foreign_key: true
  end
end
