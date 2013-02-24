class BarController < ApplicationController
  def basic_action
    render :inline => '<h1>Bar! Basic Action</h1>', :layout => 'application'
  end
  
  
  def different_params
    js :params => {
      :boolean => true, 
      :array => [1, 2, 3],
      :string => 'Banana',
      :integer => 69,
      :float => 3.1416,
      :hash => {:a => 'Hello', :b => 'World'}}
  
    render :inline => '<h1>Bar! Different Params</h1>', :layout => 'application'
  end
end
