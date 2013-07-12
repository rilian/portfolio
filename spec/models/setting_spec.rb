require 'spec_helper'

describe Setting do
  it { should have_db_column(:env).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }

  it { should have_db_index :env }

  pending
end
