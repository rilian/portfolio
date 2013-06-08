require 'spec_helper'

describe CollectionsController do
  it 'should use AlbumsController' do
    controller.should be_an_instance_of(CollectionsController)
  end

  describe 'unauthorized request' do
    context 'accessible pages' do
      after :each do
      end

      it 'should be success' do
        @collection = FactoryGirl.create(:collection, images: [FactoryGirl.create(:image)])
        get :show, id: @collection.id
        response.status.should eq(200)
        response.should render_template(:show)
      end
    end

    context 'inaccessible pages' do
      context 'collections' do
        after :each do
          response.should redirect_to root_path
          response.status.should eq(302)
        end

        it 'should redirect to homepage' do
          get :index
        end
        it 'should redirect to homepage' do
          get :new
        end
        it 'should redirect to homepage' do
          post :create
        end
      end

      context 'members' do
        before :each do
          @collection = FactoryGirl.create(:collection)
        end

        after :each do
          response.should redirect_to root_path
          response.status.should eq(302)
        end

        it 'should redirect to homepage' do
          get :edit, id: @collection.id
        end
        it 'should redirect to homepage' do
          put :update, id: @collection.id
        end
        it 'should redirect to homepage' do
          delete :destroy, id: @collection.id
        end
      end
    end
  end

  context 'authorized request' do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'new'" do
      before :each do
        get :new
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "POST 'create'" do
      before :each do
        post :create, collection: { title: 'aa AA Aa aA', description: 'Bb' }
      end

      it 'should be successful' do
        response.status.should eq(302)
        Collection.last.present?.should be_true
        Collection.last.title.should eq('aa AA Aa aA')
        Collection.last.description.should eq('Bb')
      end
    end

    describe "GET 'edit'" do
      before :each do
        @collection = FactoryGirl.create(:collection)
        get :edit, id: @collection.id
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:edit)
      end
    end

    describe "PUT 'update'" do
      before :each do
        @collection = FactoryGirl.create(:collection)
        put :update, id: @collection.id, collection: { title: 'BB bb Bb bB!', description: 'Bb' }
      end

      it 'should be successful' do
        response.status.should eq(302)
        @collection.reload
        @collection.title.should eq('BB bb Bb bB!')
        @collection.description.should eq('Bb')
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @collection = FactoryGirl.create(:collection)
        delete :destroy, id: @collection.id
      end

      it 'should be successful' do
        response.status.should eq(302)
        Collection.find_by_id(@collection.id).nil?.should be_true
      end
    end
  end
end
