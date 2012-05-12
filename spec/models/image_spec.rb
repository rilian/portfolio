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
  it { should have_db_column(:tags_cache).of_type(:string) }

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

    it "should have published_at_checkbox" do
      @image.published_at_checkbox.should == @image.published_at.present?
    end

    describe "published_at" do
      before :each do
        time_now = Time.now
        Time.stub!(:now).and_return(time_now)
      end

      describe "should be updated" do
        before :each do
          @image.published_at = nil
        end

        it "when value is nil" do
          @image.published_at_checkbox = '1'
          @image.published_at.should == Time.now
        end
      end

      describe "should be preserved" do
        it "when value is not nil initially" do
          published_at_cached = @image.published_at
          @image.published_at_checkbox = '1'
          @image.published_at.should == published_at_cached
        end
      end

      it "should set published_at to nil" do
        @image.published_at_checkbox = '0'
        @image.published_at.should == nil
      end
    end

    describe "tags_resolved" do
      it "should return well-formatted tags" do
        @image.tags = %w(aa bb cc)
        @image.tags_resolved.should == 'aa, bb, cc'
      end

      it "should set published_at to nil" do
        @image.tags_resolved = 'a, b'
        @image.tags.should == %w(a b)
      end
    end

    describe "render_data" do
      it "should render correct description and such" do
        @image.render_data.should match(@image.desc)
        @image.render_data.should match(@image.place)
        @image.render_data.should match(@image.date.strftime("%Y"))
      end
    end
  end
end
