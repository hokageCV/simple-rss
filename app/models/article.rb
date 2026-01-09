class Article < ApplicationRecord
  belongs_to :feed
  belongs_to :user

  STATUSES = { unread: "unread", read: "read" }.freeze

  scope :recent_first, -> { order(published_at: :desc) }
  scope :unread, -> { where(status: STATUSES[:unread]) }
  scope :read, -> { where(status: STATUSES[:read]) }
  scope :from_active_feeds, -> { joins(:feed).merge(Feed.active) }

  scope :of_this_week, -> { where(published_at: Time.current.beginning_of_week..Time.current.end_of_week) }
  scope :last_two_weeks, -> { where(published_at: 2.weeks.ago.beginning_of_week..Time.current.end_of_week) }
  scope :of_this_month, -> { where(published_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :older_than, ->(time) { where("created_at < ?", time) }

  validates :status, inclusion: { in: STATUSES.values }

  def toggle_status!
    self.status = (status == STATUSES[:read] ? STATUSES[:unread] : STATUSES[:read])
    save!
  end

  def self.clear_old_articles(user, cutoff: 1.month.ago)
    user.articles.read.older_than(cutoff).destroy_all
  end

  def is_read?
    self.status == STATUSES[:read]
  end
end
