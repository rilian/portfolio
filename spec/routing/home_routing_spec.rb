require "spec_helper"

describe HomeController do
  describe "routing" do
    it "recognizes and generates actions" do
      { get: "/rss" }.should route_to(controller: "home", action: "index", format: 'rss')
    end
  end
end
