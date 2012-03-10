require 'spec_helper'

describe HomeController do
  it "should use HomeController" do
    controller.should be_an_instance_of(HomeController)
  end

  describe "user" do
    describe "GET index" do
      before do
        get :index
      end

      it { response.should be_success }
      it { response.should render_template("index")}
    end
  end
end
