require 'spec_helper'

describe ApplicationController do
  it "should use HomeController" do
    controller.should be_an_instance_of(ApplicationController)
  end
end
