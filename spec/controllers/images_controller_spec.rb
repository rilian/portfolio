require 'spec_helper'

describe ImagesController do
  it "should use ImagesController" do
    controller.should be_an_instance_of(ImagesController)
  end

  context "unauthorized request" do
    it "should redirect to index" do
      get :index
      response.should redirect_to root_path
      response.status.should eq(302)
    end
  end

  context "authorized request" do
    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
      end
    end
  end
end
