class CreateInitialSetting < ActiveRecord::Migration
  def up
    # Data migration
    Setting.create!(env: 'production') if Setting.where(env: 'production').empty?
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
