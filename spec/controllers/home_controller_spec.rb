require 'spec_helper'

describe HomeController do
  it "should use HomeController" do
    controller.should be_an_instance_of(HomeController)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
      response.should render_template(:index)
    end
  end
end
