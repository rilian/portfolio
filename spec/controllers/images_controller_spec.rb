require 'spec_helper'

describe ImagesController do
  it "should use ImagesController" do
    controller.should be_an_instance_of(ImagesController)
  end

  describe "unauthorized request" do
    context "inaccessible pages" do
      after :each do
        response.should redirect_to root_path
        response.status.should eq(302)
      end

      it "should redirect to homepage" do
        get :index
      end
      it "should redirect to homepage" do
        @image = FactoryGirl.create(:image, :published_at => false)
        get :show, :id => @image.id
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

    context "accessible pages" do
      before :each do
        @image = FactoryGirl.create(:image, :published_at => Time.now)
        get :show, :id => @image.id
      end

      it "should be successful" do
        response.should be_success
        response.should render_template(:show)
        assigns[:image].should == @image
      end
    end
  end

  context "authorized request" do
    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'show'" do
      before :each do
        @image = FactoryGirl.create(:image, :published_at => false)
        get :show, :id => @image.id
      end

      it "should be successful" do
        response.should be_success
        response.should render_template(:show)
        assigns[:image].should == @image
      end
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
        @album = FactoryGirl.create(:album)
        @file = fixture_file_upload('/file_vertical.png', 'image/png')

        post :create, :image => {:album_id => @album.id, :asset => @file, :is_vertical => true, :title => 'AA', :desc => 'BB', :published_at_checkbox => '0'}
      end

      it "should be successful" do
        response.status.should eq(302)
        image = Image.last
        image.present?.should be_true
        image.title.should eq('AA')
        image.desc.should eq('BB')
        image.is_vertical?.should be_true
        image.album_id.should eq(@album.id)
        image.published_at.should == nil
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
        @image = FactoryGirl.create(:image)
        put :update, :id => @image.id, :image => {:title => 'New awesome title!'}
      end

      it "should be successful" do
        response.status.should eq(302)
        @image.reload
        @image.title.should eq('New awesome title!')
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @image = FactoryGirl.create(:image)
        delete :destroy, :id => @image.id
      end

      it "should be successful" do
        response.status.should eq(302)
        Image.find_by_id(@image.id).nil?.should be_true
      end
    end

  end
end

