class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user_id, :request_id
  delegate :user, to: :session, allow_nil: true
end
