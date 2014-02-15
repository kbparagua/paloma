require 'spec_helper'


describe MainController do

  context 'default behavior' do
    it 'executes the same controller/action pair' do
      get :index
      x = page.evaluate_script 'Paloma.engine.lastRequest'
      raise x.inspect
    end
  end

end