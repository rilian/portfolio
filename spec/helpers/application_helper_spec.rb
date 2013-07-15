require 'spec_helper'

include ApplicationHelper

describe ApplicationHelper do
  describe 'get_tags_cloud' do
    before do
      FactoryGirl.create(:image, tags_resolved: 'apple, banana, cucumber')
      FactoryGirl.create(:image, tags_resolved: 'banana, cucumber, peach')
    end

    it 'should return valid tags cloud' do
      get_tags_cloud(Image.all).should =~ [['apple', 1], ['banana', 2], ['cucumber', 2], ['peach', 1]]
    end
  end

  describe 'render_image_data' do
    let(:image) { FactoryGirl.build(:image) }
    it 'should render correct description and such' do
      render_image_data(:en, image).should match(image.desc)
      render_image_data(:en, image).should match(image.place)
      render_image_data(:en, image).should match(image.date.strftime('%Y'))
    end
  end
end
