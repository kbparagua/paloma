require 'spec_helper'


describe Paloma::Utilities do

  let(:utilities){ Paloma::Utilities }



  describe '.get_resource(path)' do
    context 'when path is only 1 word' do
      it 'returns the controller resource name' do
        expect(utilities.get_resource('test')).to eq 'Test'
      end
    end


    context 'when path is more than 1 word' do
      it 'returns the controller resource name' do
        expect(utilities.get_resource('my_super_resources')).to eq 'MySuperResources'
      end
    end


    context 'when path has namespace' do
      it 'returns "Namespace/Resource"' do
        expect(utilities.get_resource('admin/my_mega_test')).to eq 'Admin/MyMegaTest'
      end
    end


    context 'when path has 2 or more namespace' do
      it 'returns "Namespace1/NamespaceN/Resource' do
        expect(utilities.get_resource('admin/test/my_resources')).to eq 'Admin/Test/MyResources'
      end
    end
  end





  shared_examples 'resource is passed' do |resource|
    it 'returns its returned as the resource' do
      expect(route[:resource]).to eq resource
    end
  end


  shared_examples 'action is passed' do |action|
    it 'returns the action' do
      expect(route[:action]).to eq action
    end
  end


  shared_examples 'resource is not passed' do
    it 'returns a nil resource' do
      expect(route[:resource]).to be_nil
    end
  end


  shared_examples 'action is not passed' do
    it 'returns a nil action' do
      expect(route[:action]).to be_nil
    end
  end





  describe '.interpret_route(route_string)' do
    context 'when route_string is empty' do
      it 'raises an error' do
        expect { utilities.interpret_route }.to raise_error 'Empty route cannot be interpreted'
      end
    end


    context 'when route_string has a word' do
      let(:route){ utilities.interpret_route 'MyResources' }

      it_behaves_like 'resource is passed', 'MyResources'
      it_behaves_like 'action is not passed'
    end


    context 'when route_string has a namespace' do
      let(:route){ utilities.interpret_route 'Namespace/MyResource' }

      it_behaves_like 'resource is passed', 'Namespace/MyResource'
      it_behaves_like 'action is not passed'
    end


    context 'when route_string has an action' do
      let(:route){ utilities.interpret_route 'Namespace/MyResources#action' }

      it_behaves_like 'resource is passed', 'Namespace/MyResources'
      it_behaves_like 'action is passed', 'action'
    end


    context 'when route_string has action only' do
      let(:route){ utilities.interpret_route '#edit' }

      it_behaves_like 'resource is not passed'
      it_behaves_like 'action is passed', 'edit'
    end
  end

end