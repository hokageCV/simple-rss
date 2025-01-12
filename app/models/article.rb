class Article < ApplicationRecord
  belongs_to :feed
  belongs_to :user

  scope :recent_first, -> { order(published_at: :desc) }
end
