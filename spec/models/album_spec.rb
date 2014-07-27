require 'spec_helper'

describe Album do
  it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  it { should have_db_column(:title_ua).of_type(:string) }
  it { should have_db_column(:is_published).of_type(:boolean).with_options(default: true, null: false) }
  it { should have_db_column(:weight).of_type(:integer).with_options(default: 0) }
  it { should have_db_column(:is_upload_to_stock).of_type(:boolean).with_options(default: true) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:description_ua).of_type(:text) }

  it { should have_db_index(:title).unique(true) }
  it { should have_db_index(:is_published) }
  it { should have_db_index(:weight) }

  it { should validate_presence_of(:title) }

  describe 'instance' do
    before do
      FactoryGirl.create(:album)
    end

    it { should validate_uniqueness_of(:title) }
  end

  describe 'generators' do
    before do
      @album = FactoryGirl.create(:album)
    end

    it 'should be valid' do
      expect(@album).to be_valid
    end
  end

  describe 'scopes' do
    before do
      @album_1 = FactoryGirl.create(:album, weight: 1)
      @album_2 = FactoryGirl.create(:album, weight: 3)
      @album_3 = FactoryGirl.create(:album, weight: 2)
    end

    it 'default scope should return all albums by weight DESC' do
      expect(Album.by_weight.map(&:id)).to eq [@album_2.id, @album_3.id, @album_1.id]
    end
  end

  describe 'before filters' do
    describe 'should humanize text values' do
      before do
        @album = FactoryGirl.create(:album, title: 'BB bb Bb bB!')
      end

      it 'should have humanized values' do
        expect(@album.title).to eq 'BB bb Bb bB!'
      end
    end
  end

  describe 'other model methods' do
    before do
      @album = FactoryGirl.build(:album)
    end

    it 'should return to_param' do
      expect(@album.to_param).to eq("#{@album.id}-#{@album.title.parameterize}")
    end
  end
end
