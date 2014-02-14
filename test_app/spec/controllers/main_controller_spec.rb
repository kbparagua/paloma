require 'spec_helper'


describe MainController do

  context 'default behavior' do
    it 'test' do
      get :index
      raise MainController.instance
    end
  end

end