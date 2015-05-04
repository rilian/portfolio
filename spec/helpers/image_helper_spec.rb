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
        expect(check_title(@image).to_s).to match("#{Image::TITLE_MIN} words")
      end
    end

    describe 'check_desc' do
      it 'should render correct desc suggestion' do
        expect(check_desc(@image).to_s).to match("#{Image::DESC_MIN} words")
      end
    end

    describe 'check_tags' do
      it 'should render correct desc suggestion' do
        expect(check_tags(@image).to_s).to match("#{Image::TAGS_MIN} tags")
      end
    end
  end
end
