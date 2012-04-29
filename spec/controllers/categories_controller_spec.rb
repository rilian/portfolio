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
      it "should be successful" do
        get :new
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "POST 'create'" do
      before :each do
        title = FactoryGirl.generate(:title)
        post :create, :category => {:title => title}
      end

      it "should be successful" do
        response.should be_success
        Category.last.present.should be_true
        Category.last.title.should eq(title)
      end
    end

    describe "GET 'edit'" do
      it "should be successful" do
        get :edit
        response.should be_success
        response.should render_template(:edit)
      end
    end

    describe "PUT 'update'" do
      it "should be successful" do
        put :update
        response.should be_success
      end
    end

    describe "GET 'destroy'" do
      it "should be successful" do
        delete :destroy
        response.should be_success
      end
    end

  end
end
