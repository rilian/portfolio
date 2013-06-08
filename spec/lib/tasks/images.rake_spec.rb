require 'spec_helper'
require 'rake'

describe 'images' do
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/images"
    Rake::Task.define_task(:environment)
  end

  describe ':publish_unpublished' do
    before do
      @image = FactoryGirl.create(:image, published_at: nil)
    end

    it 'should not exist unpublished images' do
      Image.where(published_at: nil).size.should eq(1)
      @rake['images:publish_unpublished'].invoke
      Image.where(published_at: nil).size.should eq(0)
    end
  end
end
