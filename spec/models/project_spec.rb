require 'spec_helper'

describe Project do
  it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  it { should have_db_column(:is_published).of_type(:boolean).with_options(null: false, default: false) }
  it { should have_db_column(:description).of_type(:text) }

  it { should have_db_index :is_published }
  pending
end
