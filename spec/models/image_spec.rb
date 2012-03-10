require 'spec_helper'

describe Image do
  it { should have_db_column(:post_id).of_type(:integer) }
  it { should have_db_column(:asset).of_type(:string) }

  it { should have_db_index(:post_id) }
end
