require 'spec_helper'

include ApplicationHelper

describe ApplicationHelper do
  describe 'get_tags_cloud' do
    before do
      image_1 = FactoryGirl.create(:image)
      image_1.tags_resolved = 'apple, banana, cucumber'
      image_2 = FactoryGirl.create(:image)
      image_2.tags_resolved = 'banana, cucumber, peach'
    end

    it 'should return valid tags cloud' do
      tags_cloud = get_tags_cloud(Image.all)
      expect(tags_cloud).to match_array([['apple', 1], ['banana', 2], ['cucumber', 2], ['peach', 1]])
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


  describe 'highlight_links' do
    it 'highlights link in text' do
      highlight_links('http://google.com').should == "<a href=\"http://google.com\" rel=\"nofollow\" target=\"_blank\">http://google.com</a>"
      highlight_links('test https://site.local/?xx=123-yy test').should ==
        "test <a href=\"https://site.local/?xx=123-yy\" rel=\"nofollow\" target=\"_blank\">https://site.local/?xx=123-yy</a> test"
      highlight_links("http://www.1-1.org/Title-1\r\nhttp://www.2-2.org/Title-2").should ==
        "<a href=\"http://www.1-1.org/Title-1\" rel=\"nofollow\" target=\"_blank\">http://www.1-1.org/Title-1</a>\r\n"+
          "<a href=\"http://www.2-2.org/Title-2\" rel=\"nofollow\" target=\"_blank\">http://www.2-2.org/Title-2</a>"
      highlight_links(' aa http://unuj.org/ru/my-i-iskusstvo/item/2103-macdougall-s-privez-shedevryi-no-ne-vse.html').should ==
        " aa <a href=\"http://unuj.org/ru/my-i-iskusstvo/item/2103-macdougall-s-privez-shedevryi-no-ne-vse.html\" "+
          "rel=\"nofollow\" target=\"_blank\">http://unuj.org/ru/my-i-iskusstvo/item/2103-macdougall-s-privez-shedevryi-no-ne-vse.html</a>"
    end
  end
end
