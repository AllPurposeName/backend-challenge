class AddShortenedWebsiteToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :shortened_website, :string
  end
end
