require 'spec_helper'

describe Album do
  it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  it { should have_db_column(:is_hidden).of_type(:boolean).with_options(default: false) }
  it { should have_db_column(:weight).of_type(:integer).with_options(default: 0) }
  it { should have_db_column(:is_upload_to_stock).of_type(:boolean).with_options(default: true) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_index(:title).unique(true) }
  it { should have_db_index(:is_hidden) }
  it { should have_db_index(:weight) }

  it { should validate_presence_of(:title) }

  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :is_hidden }
  it { should allow_mass_assignment_of :weight }
  it { should allow_mass_assignment_of :is_upload_to_stock }
  it { should allow_mass_assignment_of :description }

  describe 'instance' do
    before :each do
      FactoryGirl.create(:album)
    end

    it { should validate_uniqueness_of(:title) }
  end

  describe 'generators' do
    before :each do
      @album = FactoryGirl.create(:album)
    end

    it 'should be valid' do
      @album.should be_valid
    end
  end

  describe 'scopes' do
    before do
      @album_1 = FactoryGirl.create(:album, weight: 1)
      @album_2 = FactoryGirl.create(:album, weight: 3)
      @album_3 = FactoryGirl.create(:album, weight: 2)
    end

    it 'default scope should return all albums by weight DESC' do
      Album.all.map(&:id).should == [@album_2.id, @album_3.id, @album_1.id]
    end
  end

  describe 'before filters' do
    describe 'should humanize text values' do
      before do
        @album = FactoryGirl.create(:album, title: 'BB bb Bb bB!')
      end

      it 'should have humanized values' do
        @album.title.should == 'BB bb Bb bB!'
      end
    end
  end

  describe 'other model methods' do
    before :each do
      @album = FactoryGirl.build(:album)
    end

    it 'should return to_param' do
      @album.to_param.should eq("#{@album.id}-#{@album.title.parameterize}")
    end
  end
end
