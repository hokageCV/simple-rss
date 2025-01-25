class Article < ApplicationRecord
  belongs_to :feed
  belongs_to :user

  scope :recent_first, -> { order(published_at: :desc) }

  STATUSES = { unread: "unread", read: "read" }.freeze
  validates :status, inclusion: { in: STATUSES.values }

  def toggle_status!
    self.status = (status == STATUSES[:read] ? STATUSES[:unread] : STATUSES[:read])
    save!
  end
end
