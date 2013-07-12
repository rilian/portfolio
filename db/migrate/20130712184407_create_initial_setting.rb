class CreateInitialSetting < ActiveRecord::Migration
  def up
    # Data migration
    Setting.create!(env: 'production')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
