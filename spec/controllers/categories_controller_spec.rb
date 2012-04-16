require 'spec_helper'

describe CategoriesController do
  it "should use CategoriesController" do
    controller.should be_an_instance_of(CategoriesController)
  end

  describe "anonymous user" do
    it "should redirect to the login page" do
      #
    end
  end

  describe "authenticated user" do
    before(:each) do
      authenticate_user
    end

    describe "GET show" do
      before do
        @category = FactoryGirl.create(:category, :posts => [])
        get :show, :id => @category.id
      end
      it { response.should be_success }
      it { response.should render_template("show")}
      it { assigns[:category].should == @category }
      it { assigns[:posts].should == [] }
    end
  end
end
