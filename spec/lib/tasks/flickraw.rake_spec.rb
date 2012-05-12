require 'spec_helper'
require "rake"

describe "flickraw" do
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/flickraw"
    Rake::Task.define_task(:environment)
  end

  describe ":upload_images" do
    pending
    #@rake['flickraw:get_flickr_tokens'].invoke
  end

  describe ":upload_images" do
    pending
    #@rake['flickraw:upload_images'].invoke
  end
end
