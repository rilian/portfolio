class CreateSetting < ActiveRecord::Migration
  def change
    create_table :settings, force: true do |t|
      t.string :env, null: false,         default: 'development'
      t.string :host,                     default: 'http://portfolio.local'
      t.string :title,                    default: 'Username Portfolio'
      t.string :description,              default: 'Username Portfolio - Photo & Art work'
      t.string :copyright_holder,         default: 'Developer'
      t.string :flickr_api_key,           default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :flickr_shared_secret,     default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :flickr_access_token,      default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :flickr_access_secret,     default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :flickr_user_id,           default: 'Nickname'
      t.string :google_analytics_account, default: 'UA-000000-00'
      t.string :disqus_shortname,         default: 'example'
      t.string :disqus_developer,         default: '1'
      t.string :disqus_api_secret,        default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :disqus_api_key,           default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :disqus_access_token,      default: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      t.string :linkedin_account,         default: 'http://linkedin.com/'
      t.timestamps
    end

    add_index :settings, :env, unique: true unless index_exists?(:settings, :env)
  end
end
