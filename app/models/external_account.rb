class ExternalAccount < ApplicationRecord
  belongs_to :user

  PROVIDERS = [ "raindrop" ].freeze

  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :access_token, presence: true
  validates :connected_at, presence: true

  validates :provider, uniqueness: { scope: :user_id }
end
