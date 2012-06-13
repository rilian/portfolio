require 'spec_helper'

describe Album do
  it { should have_db_column(:title).of_type(:string).with_options(:null => false) }
  it { should have_db_index(:title).unique(true) }

  it { should validate_presence_of(:title) }

  describe "instance" do
    before :each do
      FactoryGirl.create(:album)
    end

    it { should validate_uniqueness_of(:title) }
  end

  describe "generators" do
    before :each do
      @album = FactoryGirl.create(:album)
    end

    it "should be valid" do
      @album.should be_valid
    end
  end

  describe 'before filters' do
    describe "should humanize text values" do
      before do
        @album = FactoryGirl.create(:album, :title => 'BB bb Bb bB!')
      end

      it "should have humanized values" do
        @album.title.should == 'BB bb Bb bB!'
      end
    end
  end

  describe 'other model methods' do
    before :each do
      @album = FactoryGirl.build(:album)
    end

    it "should return to_param" do
      @album.to_param.should eq("#{@album.id}-#{@album.title.parameterize}")
    end
  end
end
