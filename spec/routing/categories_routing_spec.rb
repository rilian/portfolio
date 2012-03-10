require "spec_helper"

describe CategoriesController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { :get => "/categories/1" }.should route_to(:controller => "categories", :action => "show", :id => '1')
    end
  end
end
