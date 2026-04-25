class AdminConstraint
  def self.matches?(request)
    return false unless request.cookie_jar.signed[:session_id]

    session = Session.find_by(id: request.cookie_jar.signed[:session_id])
    session&.user&.admin?
  rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
    false
  end
end