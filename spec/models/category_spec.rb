require 'spec_helper'

describe Category do
  it { should have_db_column(:title).of_type(:string) }

  it { should have_db_index(:title).unique(true) }

  it { should validate_presence_of(:title) }

  describe "instance" do
    subject {
      Category.create(:title => 'A')
    }
    it { should validate_uniqueness_of(:title) }
  end
end
