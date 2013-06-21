require 'spec_helper'

describe Collection do
  it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  it { should have_db_column(:is_hidden).of_type(:boolean).with_options(default: false) }
  it { should have_db_column(:weight).of_type(:integer).with_options(default: 0) }
  it { should have_db_column(:is_upload_to_stock).of_type(:boolean).with_options(default: true) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_index(:title).unique(true) }
  it { should have_db_index(:is_hidden) }
  it { should have_db_index(:weight) }

  it { should validate_presence_of(:title) }

  it { should allow_mass_assignment_of :type }
  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :is_hidden }
  it { should allow_mass_assignment_of :weight }
  it { should allow_mass_assignment_of :is_upload_to_stock }
  it { should allow_mass_assignment_of :description }

  describe 'instance' do
    before :each do
      FactoryGirl.create(:collection)
    end

    it { should validate_uniqueness_of(:title) }
  end

  describe 'generators' do
    before :each do
      @collection = FactoryGirl.create(:collection)
    end

    it 'should be valid' do
      @collection.should be_valid
    end
  end

  describe 'scopes' do
    before do
      @collection_1 = FactoryGirl.create(:collection, weight: 1)
      @collection_2 = FactoryGirl.create(:collection, weight: 3)
      @collection_3 = FactoryGirl.create(:collection, weight: 2)
    end

    it 'default scope should return all albums by weight DESC' do
      Collection.all.map(&:id).should == [@collection_2.id, @collection_3.id, @collection_1.id]
    end
  end

  describe 'before filters' do
    describe 'should humanize text values' do
      before do
        @collection = FactoryGirl.create(:collection, title: 'BB bb Bb bB!')
      end

      it 'should have humanized values' do
        @collection.title.should == 'BB bb Bb bB!'
      end
    end
  end

  describe 'other model methods' do
    before :each do
      @collection = FactoryGirl.build(:collection)
    end

    it 'should return to_param' do
      @collection.to_param.should eq("#{@collection.id}-#{@collection.title.parameterize}")
    end
  end
end
