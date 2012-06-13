require 'spec_helper'

describe Image do
  it { should have_db_column(:album_id).of_type(:integer) }
  it { should have_db_column(:asset).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:desc).of_type(:text) }
  it { should have_db_column(:place).of_type(:string) }
  it { should have_db_column(:date).of_type(:date) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:tags_cache).of_type(:string) }
  it { should have_db_column(:uploaded_to_flickr_at).of_type(:datetime) }
  it { should have_db_column(:flickr_photo_id).of_type(:string).with_options(:limit => 11) }
  it { should have_db_column(:deviantart_id).of_type(:string).with_options(:limit => 8) }

  it { should have_db_index(:album_id) }
  it { should have_db_index(:published_at) }
  it { should have_db_index(:uploaded_to_flickr_at) }

  it { should validate_presence_of(:asset) }
  it { should validate_presence_of(:album) }
  it { should validate_presence_of(:title) }

  describe "generators" do
    before :each do
      @image = FactoryGirl.create(:image)
    end

    it "should be valid" do
      @image.should be_valid
    end
  end

  describe 'before filters' do
    describe "should humanize text values" do
      before do
        @image = FactoryGirl.create(:image, :title => 'aa AA aA Aa', :desc => 'bb BB bB Bb', :place => 'cc CC Cc cC', :tags => 'xx, yy, qQ')
      end

      it "should have humanized values" do
        @image.title.should == 'aa AA aA Aa'
        @image.desc.should == 'bb BB bB Bb'
        @image.place.should == 'cc CC Cc cC'
        @image.tags_cache.should == 'xx, yy, qQ'
      end
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

    describe "uploaded_to_flickr_at" do
      before :each do
        time_now = Time.now
        Time.stub!(:now).and_return(time_now)
      end

      describe "should be updated" do
        before :each do
          @image.uploaded_to_flickr_at = nil
        end

        it "when value is nil" do
          @image.uploaded_to_flickr_at_checkbox = '1'
          @image.uploaded_to_flickr_at.should == Time.now
        end
      end

      describe "should be preserved" do
        it "when value is not nil initially" do
          uploaded_to_flickr_at_cached = @image.uploaded_to_flickr_at
          @image.uploaded_to_flickr_at_checkbox = '1'
          @image.uploaded_to_flickr_at.should == uploaded_to_flickr_at_cached
        end
      end

      it "should set published_at to nil" do
        @image.uploaded_to_flickr_at_checkbox = '0'
        @image.uploaded_to_flickr_at.should == nil
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
