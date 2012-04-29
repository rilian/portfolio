require 'spec_helper'

describe Image do
  it { should have_db_column(:category_id).of_type(:integer) }
  it { should have_db_column(:asset).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:desc).of_type(:text) }
  it { should have_db_column(:is_vertical).of_type(:boolean) }

  it { should have_db_index(:category_id) }

  it { should validate_presence_of(:asset) }
  it { should validate_presence_of(:category) }

  describe "generators" do
    before :each do
      @image = FactoryGirl.create(:image)
    end

    it "should be valid" do
      @image.should be_valid
    end
  end

  describe 'other model methods' do
    before :each do
      @image = FactoryGirl.build(:image)
    end

    it "should return to_param" do
      @image.to_param.should eq("#{@image.id}-#{@image.title.parameterize}")
    end
  end
end
