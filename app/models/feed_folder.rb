class FeedFolder < ApplicationRecord
  belongs_to :feed
  belongs_to :folder
  belongs_to :user

  validates :feed_id, uniqueness: { scope: :folder_id }
end
