require 'spec_helper'

describe Project do
  it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  it { should have_db_column(:title_ru).of_type(:string) }
  it { should have_db_column(:is_published).of_type(:boolean).with_options(null: false, default: false) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:description_ru).of_type(:text) }
  it { should have_db_column(:info).of_type(:text) }
  it { should have_db_column(:info_ru).of_type(:text) }
  it { should have_db_column(:weight).of_type(:integer).with_options(null: false, default: 0) }

  it { should have_db_index :is_published }
  it { should have_db_index :weight }

  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :title_ru }
  it { should allow_mass_assignment_of :info }
  it { should allow_mass_assignment_of :info_ru }
  it { should allow_mass_assignment_of :description }
  it { should allow_mass_assignment_of :description_ru }

  pending
end
