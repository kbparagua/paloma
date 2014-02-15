require 'spec_helper'


describe Paloma::Controller do

  let(:controller){ Paloma::Controller.new }


  before do
    controller.resource = 'Test'
    controller.action = 'new'
    controller.params = {:x => 1, :y => 2}
  end



  shared_examples 'request is cleared' do
    it 'assigns nil to resource' do
      expect(controller.resource).to be_nil
    end


    it 'assigns nil to action' do
      expect(controller.action).to be_nil
    end


    it 'assigns an empty hash to params' do
      expect(controller.params).to be_empty
    end


    it 'returns true' do
      expect(@return).to be_true
    end
  end



  shared_examples 'request is not cleared' do
    it 'returns false' do
      expect(@return).to be_false
    end


    it 'has a request' do
      expect(controller.has_request?).to be_true
    end
  end





  describe '#clear_request' do
    before { @return = controller.clear_request }
    it_behaves_like 'request is cleared'
  end



  describe '#request' do
    it 'returns a hash object' do
      expect(controller.request).to be_an_instance_of Hash
    end


    it 'returns the current value of resource' do
      expect(controller.request[:resource]).to eq 'Test'
    end


    it 'returns the current value of action' do
      expect(controller.request[:action]).to eq 'new'
    end


    it 'returns the current value of params' do
      expect(controller.request[:params]).to eq ({:x => 1, :y => 2})
    end
  end



  describe '#has_request?' do
    context 'when resource is nil' do
      it 'returns false' do
        controller.resource = nil
        expect(controller.has_request?).to be_false
      end
    end


    context 'when action is nil' do
      it 'returns false' do
        controller.action = nil
        expect(controller.has_request?).to be_false
      end
    end


    context 'when resource and action is present' do
      it 'returns true' do
        expect(controller.has_request?).to be_true
      end
    end
  end

end