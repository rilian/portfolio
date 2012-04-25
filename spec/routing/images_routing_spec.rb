require "spec_helper"

describe ImagesController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :get => "/images" }.should route_to(:controller => "images", :action => "index")
      { :get => "/images/1" }.should route_to(:controller => "images", :action => "show", :id => '1')
      { :get => "/images/new" }.should route_to(:controller => "images", :action => "new")
      { :get => "/images/1/edit" }.should route_to(:controller => "images", :action => "edit", :id => '1')
      { :put => "/images/1" }.should route_to(:controller => "images", :action => "update", :id => '1')
      { :post => "/images" }.should route_to(:controller => "images", :action => "create")
      { :delete => "/images/1" }.should route_to(:controller => "images", :action => "destroy", :id => '1')

      { :post => "/images/cache_uploader" }.should route_to(:controller => "images", :action => "cache_uploader")
      { :put => "/images/cache_uploader" }.should route_to(:controller => "images", :action => "cache_uploader")
    end
  end
end