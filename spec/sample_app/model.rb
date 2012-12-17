# Model
class Article
  attr_accessible :title, :body
end


# Migration
class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t| 
      t.string :title
      t.string :body
    end
  end
end


ActiveRecord::Migration.verbose = false
CreateArticles.up
