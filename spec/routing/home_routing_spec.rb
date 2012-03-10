require "spec_helper"

describe HomeController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :get => "/index" }.should route_to(:controller => "home", :action => "index")
      { :get => "/contacts" }.should route_to(:controller => "home", :action => "contacts")
      { :get => "/about" }.should route_to(:controller => "home", :action => "about")
    end
  end
end
