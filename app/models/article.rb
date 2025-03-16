class Article < ApplicationRecord
  belongs_to :feed
  belongs_to :user

  scope :recent_first, -> { order(published_at: :desc) }
  scope :unread, -> { where(status: "unread") }

  scope :of_this_week, -> { where(published_at: Time.current.beginning_of_week..Time.current.end_of_week) }
  scope :last_two_weeks, -> { where(published_at: 2.weeks.ago.beginning_of_week..Time.current.end_of_week) }
  scope :of_this_month, -> { where(published_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  STATUSES = { unread: "unread", read: "read" }.freeze
  validates :status, inclusion: { in: STATUSES.values }

  def toggle_status!
    self.status = (status == STATUSES[:read] ? STATUSES[:unread] : STATUSES[:read])
    save!
  end
end
