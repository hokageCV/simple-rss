namespace :oauth do
  get    "/raindrop/connect",    to: "raindrop#connect"
  get    "/raindrop/callback",   to: "raindrop#callback"
  delete "/raindrop/disconnect", to: "raindrop#disconnect"
end
