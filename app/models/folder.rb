class Folder < ApplicationRecord
  belongs_to :user
  has_many :feed_folders, dependent: :destroy
  has_many :feeds, through: :feed_folders
  has_many :articles, through: :feeds

  validates :name, presence: true
end
