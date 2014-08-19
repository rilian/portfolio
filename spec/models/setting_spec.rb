require 'spec_helper'

describe Setting do
  it { is_expected.to have_db_column(:env).of_type(:string) }
  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:contact_text).of_type(:text) }
  it { is_expected.to have_db_column(:contact_text_ua).of_type(:text) }
  it { is_expected.to have_db_column(:facebook_account).of_type(:string) }

  it { is_expected.to have_db_index :env }
end
