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
      response.content_type.should eq("text/html")
    end
  end

  describe "GET 'rss'" do
    it "should be successful" do
      get :index, format: :rss
      response.should be_success
      response.should render_template(:index)
      response.content_type.should eq("application/rss+xml")
    end
  end
end
