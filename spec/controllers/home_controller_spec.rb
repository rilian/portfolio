require 'spec_helper'

describe HomeController do
  it "should use HomeController" do
    controller.should be_an_instance_of(HomeController)
  end

  describe "user" do
    %w(contacts).each do |page|
      describe "GET #{page}" do
        before do
          get page.to_sym
        end
        it { response.should be_success }
        it { response.should render_template(page) }
      end
    end
  end
end
