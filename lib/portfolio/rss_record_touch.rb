##
# Extend ActiveRecord models to support creation of related RssRecord
#
module Portfolio::RssRecordTouch
  def self.included(base)
    base.class_eval do
      after_create :update_rss_record, if: Proc.new { |m| m.is_published? }
      after_update :update_rss_record, if: Proc.new { |m| m.is_published_changed? && m.is_published? }
    end
  end

  ##
  # Create or touch RssRecord related to updated model
  #
  def update_rss_record
    rss_record = RssRecord.where(owner_type: self.class.to_s, owner_id: self.id).first
    unless rss_record
      RssRecord.create(owner_type: self.class.to_s, owner_id: self.id)
    else
      rss_record.touch
    end
  end
end
