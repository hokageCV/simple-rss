class Feed < ApplicationRecord
  belongs_to :user
  has_many :articles, dependent: :destroy

  scope :alphabetically, -> { order(Arel.sql("LOWER(name) ASC")) }
end
