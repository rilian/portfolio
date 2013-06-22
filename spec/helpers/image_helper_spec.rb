require 'spec_helper'

include ImageHelper

describe ImageHelper do
  describe 'check descriptions' do
    before do
      @image = FactoryGirl.create(:image)
      @image.place = ''
      @image.desc = ''
      @image.title = '1 2 3'
    end

    describe 'check_title' do
      it 'should render correct title suggestion' do
        @image.is_for_sale = false
        check_title(@image).to_s.should match("#{Image::TITLE_MIN} words")
        @image.is_for_sale = true
        check_title(@image).to_s.should match("#{Image::TITLE_MIN_FOR_SALE} words")
      end
    end

    describe 'check_desc' do
      it 'should render correct desc suggestion' do
        @image.is_for_sale = false
        check_desc(@image).to_s.should match("#{Image::DESC_MIN} words")
        @image.is_for_sale = true
        check_desc(@image).to_s.should match("#{Image::DESC_MIN_FOR_SALE} words")
      end
    end

    describe 'check_tags' do
      it 'should render correct desc suggestion' do
        @image.is_for_sale = false
        check_tags(@image).to_s.should match("#{Image::TAGS_MIN} tags")
        @image.is_for_sale = true
        check_tags(@image).to_s.should match("#{Image::TAGS_MIN_FOR_SALE} tags")
      end
    end
  end

  describe 'highlight_links' do
    it 'highlights link in text' do
      highlight_links('http://google.com').should == "<a href='http://google.com' rel='nofollow'>http://google.com</a>"
      highlight_links('test https://site.local/?xx=123-yy test').should ==
        "test <a href='https://site.local/?xx=123-yy' rel='nofollow'>https://site.local/?xx=123-yy</a> test"
      highlight_links("http://www.1-1.org/Title-1\r\nhttp://www.2-2.org/Title-2").should ==
        "<a href='http://www.1-1.org/Title-1' rel='nofollow'>http://www.1-1.org/Title-1</a>\r\n"+
        "<a href='http://www.2-2.org/Title-2' rel='nofollow'>http://www.2-2.org/Title-2</a>"
    end
  end
end
