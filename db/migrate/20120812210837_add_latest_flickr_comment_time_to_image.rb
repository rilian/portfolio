class AddLatestFlickrCommentTimeToImage < ActiveRecord::Migration
  def change
    add_column :images, :flickr_comment_time, :integer, default: 0
  end
end
