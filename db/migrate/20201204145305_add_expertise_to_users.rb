class AddExpertiseToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :expertise, :text, array: true, default: []
  end
end
