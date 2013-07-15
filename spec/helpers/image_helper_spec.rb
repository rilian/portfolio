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
end
