require 'spec_helper'

describe Post do
  it { should have_db_column(:category_id).of_type(:integer) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
  it { should have_db_column(:body_full).of_type(:text) }
  it { should have_db_column(:is_published).of_type(:boolean).with_options(:default => false) }

  it { should have_db_index(:category_id) }
  it { should have_db_index(:is_published) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  describe "generators" do
    before :each do
      @post = Factory(:post)
    end

    it "should be valid" do
      @post.should be_valid
    end
  end
end
