require 'spec_helper'

describe Image do
  it { should have_db_column(:album_id).of_type(:integer) }
  it { should have_db_column(:asset).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:desc).of_type(:text) }
  it { should have_db_column(:place).of_type(:string) }
  it { should have_db_column(:date).of_type(:date) }
  it { should have_db_column(:is_vertical).of_type(:boolean) }
  it { should have_db_column(:published_at).of_type(:datetime) }

  it { should have_db_index(:album_id) }
  it { should have_db_index(:published_at) }

  it { should validate_presence_of(:asset) }
  it { should validate_presence_of(:album) }

  describe "generators" do
    before :each do
      @image = FactoryGirl.create(:image)
    end

    it "should be valid" do
      @image.should be_valid
    end
  end

  describe 'instance methods' do
    before :each do
      @image = FactoryGirl.build(:image)
    end

    it "should return to_param" do
      @image.to_param.should eq("#{@image.id}-#{@image.title.parameterize}")
    end
  end

  describe 'class methods' do
    describe "should publish_unpublished" do
      before :each do
        @image = FactoryGirl.create(:image, :published_at => nil)
      end

      it "should not exist unpublished images" do
        Image.where(:published_at => nil).size.should eq(1)
        Image.publish_unpublished
        Image.where(:published_at => nil).size.should eq(0)
      end
    end
  end
end
