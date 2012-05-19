require 'spec_helper'

describe AlbumsController do
  it "should use AlbumsController" do
    controller.should be_an_instance_of(AlbumsController)
  end

  describe "unauthorized request" do
    context "accessible pages" do
      after :each do
      end

      it "should be success" do
        @album = FactoryGirl.create(:album, :images => [FactoryGirl.create(:image)])
        get :show, :id => @album.id
        response.status.should eq(200)
        response.should render_template(:show)
      end
    end

    context "inaccessible pages" do
      after :each do
        response.should redirect_to root_path
        response.status.should eq(302)
      end

      it "should redirect to homepage" do
        get :index
      end
      it "should redirect to homepage" do
        get :new
      end
      it "should redirect to homepage" do
        post :create
      end
      it "should redirect to homepage" do
        get :edit
      end
      it "should redirect to homepage" do
        put :update
      end
      it "should redirect to homepage" do
        delete :destroy
      end
    end
  end

  context "authorized request" do
    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'new'" do
      before :each do
        get :new
      end

      it "should be successful" do
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "POST 'create'" do
      before :each do
        post :create, :album => {:title => 'AA AA'}
      end

      it "should be successful" do
        response.status.should eq(302)
        Album.last.present?.should be_true
        Album.last.title.should eq('Aa Aa')
      end
    end

    describe "GET 'edit'" do
      before :each do
        get :edit
      end

      it "should be successful" do
        response.should be_success
        response.should render_template(:edit)
      end
    end

    describe "PUT 'update'" do
      before :each do
        @album = FactoryGirl.create(:album)
        put :update, :id => @album.id, :album => {:title => 'New awesome title!'}
      end

      it "should be successful" do
        response.status.should eq(302)
        @album.reload
        @album.title.should eq('New Awesome Title!')
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @album = FactoryGirl.create(:album)
        delete :destroy, :id => @album.id
      end

      it "should be successful" do
        response.status.should eq(302)
        Album.find_by_id(@album.id).nil?.should be_true
      end
    end

  end
end
