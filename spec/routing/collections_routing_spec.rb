require "spec_helper"

describe CollectionsController do
  describe "routing" do
    it "recognizes and generates CRUD" do
      { get: "/collections" }.should route_to(controller: "collections", action: "index")
      { get: "/collections/1" }.should route_to(controller: "collections", action: "show", id: '1')
      { get: "/collections/new" }.should route_to(controller: "collections", action: "new")
      { get: "/collections/1/edit" }.should route_to(controller: "collections", action: "edit", id: '1')
      { put: "/collections/1" }.should route_to(controller: "collections", action: "update", id: '1')
      { post: "/collections" }.should route_to(controller: "collections", action: "create")
      { delete: "/collections/1" }.should route_to(controller: "collections", action: "destroy", id: '1')
    end
  end
end
