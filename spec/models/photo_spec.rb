require 'spec_helper'

describe Photo do
  describe 'database' do
    it { should have_db_column(:image_width).of_type(:integer) }
    it { should have_db_column(:image_height).of_type(:integer) }

    pending
  end
end
