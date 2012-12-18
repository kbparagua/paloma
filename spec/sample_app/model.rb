# ActiveRecord Configuration
require 'active_record/railtie'
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')


# Model
class Article < ActiveRecord::Base
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
