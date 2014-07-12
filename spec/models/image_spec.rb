require 'spec_helper'

describe Image do
  it { should have_db_column(:album_id).of_type(:integer) }
  it { should have_db_column(:asset).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:title_ua).of_type(:string) }
  it { should have_db_column(:desc).of_type(:text) }
  it { should have_db_column(:desc_ua).of_type(:text) }
  it { should have_db_column(:place).of_type(:string) }
  it { should have_db_column(:place_ua).of_type(:string) }
  it { should have_db_column(:date).of_type(:date) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:tags_cache).of_type(:string) }
  it { should have_db_column(:flickr_photo_id).of_type(:string).with_options(limit: 11) }
  it { should have_db_column(:deviantart_link).of_type(:string) }
  it { should have_db_column(:istockphoto_link).of_type(:string) }
  it { should have_db_column(:shutterstock_link).of_type(:string) }
  it { should have_db_column(:flickr_comment_time).of_type(:integer).with_options(default: 0) }
  it { should have_db_column(:is_for_sale).of_type(:boolean).with_options(default: false) }
  it { should have_db_column(:image_width).of_type(:integer) }
  it { should have_db_column(:image_height).of_type(:integer) }

  it { should have_db_index(:album_id) }
  it { should have_db_index(:published_at) }

  it { should validate_presence_of(:album) }
  it { should validate_presence_of(:title) }

  it { should validate_numericality_of(:flickr_photo_id) }

  describe 'generators' do
    before :each do
      @image = FactoryGirl.create(:image)
    end

    it 'should be valid' do
      expect(@image).to be_valid
    end
  end

  describe 'scopes' do
    describe '.published' do
      pending
    end
    describe '.from_published_album' do
      pending
    end
  end

  describe 'instance methods' do
    before :each do
      @image = FactoryGirl.build(:image)
    end

    it 'should return to_param' do
      expect(@image.to_param).to eq("#{@image.id}-#{@image.title.parameterize}")
    end

    it 'should have published_at_checkbox' do
      expect(@image.published_at_checkbox).to eq @image.published_at.present?
    end

    describe 'published_at' do
      describe 'should be updated' do
        before :each do
          @image.published_at = nil
        end

        it 'when value is nil' do
          @image.published_at_checkbox = '1'
          expect(@image.published_at).to_not eq nil
        end
      end

      describe 'should be preserved' do
        it 'when value is not nil initially' do
          published_at_cached = @image.published_at
          @image.published_at_checkbox = '1'
          expect(@image.published_at).to eq published_at_cached
        end
      end

      it 'should set published_at to nil' do
        @image.published_at_checkbox = '0'
        expect(@image.published_at).to eq nil
      end
    end

    describe 'tags_resolved' do
      before do
        @image = FactoryGirl.create(:image)
        @image.tags_resolved = 'apple, banana, cucumber'
      end

      it 'should return well-formatted tags' do
        expect(@image.reload.tags_resolved).to eq 'apple, banana, cucumber'
        expect(Tag.count).to eq 3
        expect(ImageTag.count).to eq 3
      end
    end
  end
end
