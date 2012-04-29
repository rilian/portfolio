require 'spec_helper'

describe CategoriesController do
  it "should use CategoriesController" do
    controller.should be_an_instance_of(CategoriesController)
  end

  describe "unauthorized request" do
    context "accessible pages" do
      after :each do
      end

      it "should be success" do
        get :index
        response.status.should eq(200)
        response.should render_template(:index)
      end

      it "should be success" do
        @category = FactoryGirl.create(:category, :images => [FactoryGirl.create(:image)])
        get :show, :id => @category.id
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
        post :create, :category => {:title => 'AA'}
      end

      it "should be successful" do
        response.status.should eq(302)
        Category.last.present?.should be_true
        Category.last.title.should eq('AA')
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
        @category = FactoryGirl.create(:category)
        put :update, :id => @category.id, :category => {:title => 'New awesome title!'}
      end

      it "should be successful" do
        response.status.should eq(302)
        @category.reload
        @category.title.should eq('New awesome title!')
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @category = FactoryGirl.create(:category)
        delete :destroy, :id => @category.id
      end

      it "should be successful" do
        response.status.should eq(302)
        Category.find_by_id(@category.id).nil?.should be_true
      end
    end

  end
end
