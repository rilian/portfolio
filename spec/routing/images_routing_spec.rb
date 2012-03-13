require "spec_helper"

describe ImagesController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :post => "/images/cache_uploader" }.should route_to(:controller => "images", :action => "cache_uploader")
      { :delete => "/images/1" }.should route_to(:controller => "images", :action => "destroy", :id => '1')
    end
  end
end
