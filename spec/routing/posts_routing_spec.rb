require "spec_helper"

describe PostsController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :get => "/posts" }.should route_to(:controller => "posts", :action => "index")
      { :post => "/posts" }.should route_to(:controller => "posts", :action => "create")
      { :get => "/posts/new" }.should route_to(:controller => "posts", :action => "new")
      { :get => "/posts/1/edit" }.should route_to(:controller => "posts", :action => "edit", :id => '1')
      { :get => "/posts/1" }.should route_to(:controller => "posts", :action => "show", :id => '1')
      { :put => "/posts/1" }.should route_to(:controller => "posts", :action => "update", :id => '1')
      { :delete => "/posts/1" }.should route_to(:controller => "posts", :action => "destroy", :id => '1')
    end
  end
end
