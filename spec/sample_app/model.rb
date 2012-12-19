# ActiveRecord Configuration
# We are not using :memory: database to handle javascript requests on controller
require 'active_record/railtie'
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => 'paloma_test'}}
ActiveRecord::Base.establish_connection('test')


# Model
class Article < ActiveRecord::Base
  attr_accessible :title, :body
  
  validates_presence_of :title
end


# Migration
class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles, :force => true do |t| 
      t.string :title
      t.string :body
    end
  end
end


ActiveRecord::Migration.verbose = false
CreateArticles.up
