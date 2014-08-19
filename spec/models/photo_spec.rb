require 'spec_helper'

describe Photo do
  describe 'database' do
    it { is_expected.to have_db_column(:weight).of_type(:integer).with_options(default: 0, null: false) }
    it { is_expected.to have_db_column(:image_width).of_type(:integer) }
    it { is_expected.to have_db_column(:image_height).of_type(:integer) }
    it { is_expected.to have_db_column(:desc).of_type(:text) }
    it { is_expected.to have_db_column(:desc_ua).of_type(:text) }
  end
end
