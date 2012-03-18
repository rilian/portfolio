require 'spec_helper'

describe Post do
  it { should have_db_column(:category_id).of_type(:integer) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
  it { should have_db_column(:is_published).of_type(:boolean).with_options(:default => false) }

  it { should have_db_index(:category_id) }
  it { should have_db_index(:is_published) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:category) }

  describe "generators" do
    before :each do
      @post = Factory(:post)
    end

    it "should be valid" do
      @post.should be_valid
    end
  end

  describe "public methods" do
    describe "body_intro" do
      context "with delimiter" do
        before do
          @post = Factory(:post, :body => "Intro#{Post::DELIMITER}Full")
        end
        it "should be valid" do
          @post.body_intro.should == 'Intro'
        end
      end
      context "without delimiter" do
        before do
          @post = Factory(:post, :body => "Intro Full")
        end
        it "should be valid" do
          @post.body_intro.should == 'Intro Full'
        end
      end
    end
  end
end
