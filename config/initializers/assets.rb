Refinery::Core.configure do |config|
  # Register extra javascript for backend
  config.register_javascript "wymeditor_monkeypatch.js"

  # Register extra stylesheet for backend (optional options)
  config.register_stylesheet "refinerycms-videojs-admin.css",:media => 'screen'
end
Rails.application.config.assets.precompile += %w( refinerycms-videojs-admin.css wymeditor-monkeypatch.js )
Rails.application.config.assets.precompile  += /\.(?:svg)\z/
