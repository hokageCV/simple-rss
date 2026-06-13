class User < ApplicationRecord
  PROVIDERS = %w[
    openai
    anthropic
    gemini
    deepseek
    mistral
    xai
    perplexity
    openrouter
  ].freeze

  def self.api_key_config_for(provider)
    :"#{provider}_api_key"
  end

  def self.build_llm_context(provider, api_key)
    RubyLLM.context do |config|
      config.send(:"#{api_key_config_for(provider)}=", api_key)
    end
  end

  def llm_context
    self.class.build_llm_context(provider, api_key)
  end

  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :feeds, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :feed_folders, dependent: :destroy
  has_many :external_accounts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:password_digest] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password_digest] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password_digest] }
  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :model, presence: true, if: -> { api_key.present? }

  encrypts :api_key, deterministic: true

  def ai_configured?
    api_key.present? && model.present?
  end

  def raindrop_connected?
    external_accounts.exists?(provider: "raindrop")
  end

  def admin?
    is_admin?
  end
end
