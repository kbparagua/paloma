# ActiveRecord Configuration
# We are not using :memory: database to handle javascript requests on controller
require 'active_record/railtie'
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => 'paloma_test'}}
ActiveRecord::Base.establish_connection('test')


# Models
class Article < ActiveRecord::Base
  attr_accessible :title, :body, :category, :category_id
  belongs_to :category
  validates_presence_of :title
end


class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :articles, :dependent => :destroy
  validates_presence_of :name
end


# Migration
class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :articles, :force => true do |t| 
      t.string :title
      t.string :body
      t.references :category
    end
    
    create_table :categories, :force => true do |t|
      t.string :name
    end
  end
end


ActiveRecord::Migration.verbose = false
CreateTables.up
