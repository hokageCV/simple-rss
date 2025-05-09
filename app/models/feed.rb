class Feed < ApplicationRecord
  belongs_to :user

  has_many :articles, dependent: :destroy
  has_many :feed_folders, dependent: :destroy
  has_many :folders, through: :feed_folders

  validates :url, presence: true, uniqueness: { scope: :user_id, message: "Feed with this URL already exists." }

  scope :active, -> { where(is_paused: false) }
  scope :paused, -> { where(is_paused: true) }
  scope :alphabetically, -> { order(Arel.sql("LOWER(name) ASC")) }

  GENERATORS = { default: "", youtube: "youtube", reddit: "reddit", substack: "substack" }.freeze
end
