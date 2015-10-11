require 'spec_helper'

describe Image do
  it { is_expected.to have_db_column(:album_id).of_type(:integer) }
  it { is_expected.to have_db_column(:asset).of_type(:string) }
  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:title_ua).of_type(:string) }
  it { is_expected.to have_db_column(:desc).of_type(:text) }
  it { is_expected.to have_db_column(:desc_ua).of_type(:text) }
  it { is_expected.to have_db_column(:place).of_type(:string) }
  it { is_expected.to have_db_column(:place_ua).of_type(:string) }
  it { is_expected.to have_db_column(:date).of_type(:date) }
  it { is_expected.to have_db_column(:published_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:tags_cache).of_type(:string) }
  it { is_expected.to have_db_column(:image_width).of_type(:integer) }
  it { is_expected.to have_db_column(:image_height).of_type(:integer) }

  it { is_expected.to have_db_index(:album_id) }
  it { is_expected.to have_db_index(:published_at) }

  it { is_expected.to validate_presence_of(:album) }
  it { is_expected.to validate_presence_of(:title) }

  describe 'generators' do
    before do
      @image = FactoryGirl.create(:image)
    end

    it 'should be valid' do
      expect(@image).to be_valid
    end
  end

  describe 'scopes' do
    describe '.published' do
      before do
        @image_1 = FactoryGirl.create(:image, published_at: 1.minute.ago)
        @image_2 = FactoryGirl.create(:image, published_at: 1.minutes.ago)
        image_3 = FactoryGirl.create(:image, published_at: nil)
      end

      it 'returns published images' do
        expect(Image.published.map(&:id)).to match_array([@image_1.id, @image_2.id])
      end
    end

    describe '.from_published_albums' do
      before do
        album_1 = FactoryGirl.create(:album, is_published: true)
        @image_1 = FactoryGirl.create(:image, album: album_1)
        album_2 = FactoryGirl.create(:album, is_published: true)
        @image_2 = FactoryGirl.create(:image, album: album_2)
        album_4 = FactoryGirl.create(:album, is_published: false)
        FactoryGirl.create(:image, album: album_4)
      end

      it 'returns images from published Albums' do
        expect(Image.from_published_albums.map(&:id)).to match_array([@image_1.id, @image_2.id])
      end
    end

    describe '.sorted' do
      pending
    end
  end

  describe 'instance methods' do
    before do
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
        before do
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
        expect(@image.reload.tags_resolved.split(', ')).to match_array(%w[apple banana cucumber])
        expect(Tag.count).to eq 3
        expect(ImageTag.count).to eq 3
      end
    end
  end
end
