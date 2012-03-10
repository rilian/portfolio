require "spec_helper"

describe ImagesController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :put => "/images/1" }.should route_to(:controller => "images", :action => "update", :id => '1')
      { :delete => "/images/1" }.should route_to(:controller => "images", :action => "destroy", :id => '1')
    end
  end
end
