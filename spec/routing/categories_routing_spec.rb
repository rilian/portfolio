require "spec_helper"

describe CategoriesController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :get => "/categories" }.should route_to(:controller => "categories", :action => "index")
      { :get => "/categories/1" }.should route_to(:controller => "categories", :action => "show", :id => '1')
      { :get => "/categories/new" }.should route_to(:controller => "categories", :action => "new")
      { :get => "/categories/1/edit" }.should route_to(:controller => "categories", :action => "edit", :id => '1')
      { :put => "/categories/1" }.should route_to(:controller => "categories", :action => "update", :id => '1')
      { :post => "/categories" }.should route_to(:controller => "categories", :action => "create")
      { :delete => "/categories/1" }.should route_to(:controller => "categories", :action => "destroy", :id => '1')
    end
  end
end
