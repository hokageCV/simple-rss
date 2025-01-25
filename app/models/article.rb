class Article < ApplicationRecord
  belongs_to :feed
  belongs_to :user

  scope :recent_first, -> { order(published_at: :desc) }
  scope :of_this_week, -> {
    where("published_at >= ?", Time.current.beginning_of_week)
    .where("published_at <= ?", Time.current)
  }
  scope :of_this_month, -> {
    where("published_at >= ?", Time.current.beginning_of_month)
    .where("published_at <= ?", Time.current)
  }
  scope :unread, -> { where(status: "unread") }

  STATUSES = { unread: "unread", read: "read" }.freeze
  validates :status, inclusion: { in: STATUSES.values }

  def toggle_status!
    self.status = (status == STATUSES[:read] ? STATUSES[:unread] : STATUSES[:read])
    save!
  end
end
