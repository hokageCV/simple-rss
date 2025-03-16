class Feed < ApplicationRecord
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :url, presence: true, uniqueness: { scope: :user_id, message: "Feed with this URL already exists." }

  scope :active, -> { where(is_paused: false) }
  scope :paused, -> { where(is_paused: true) }
  scope :alphabetically, -> { order(Arel.sql("LOWER(name) ASC")) }
end
