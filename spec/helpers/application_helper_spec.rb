require 'spec_helper'

describe ApplicationHelper do
  describe "get_tags_cloud" do
    before do
      @image_1 = FactoryGirl.create(:image, :tags_resolved => 'apple, banana, cucumber')
      @image_2 = FactoryGirl.create(:image, :tags_resolved => 'banana, cucumber, peach')
    end

    it "should return valid tags cloud" do
      get_tags_cloud.should =~ [["apple", 1], ["banana", 2], ["cucumber", 2], ["peach", 1]]
    end
  end
end
