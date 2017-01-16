Refinery::Core.configure do |config|
	# Register extra javascript for backend
  config.register_javascript "refinery/admin/wymeditor_monkeypatch"

	# Register extra stylesheet for backend
  config.register_stylesheet "refinery/admin/refinerycms-videojs-admin", :media => 'screen'
end
Rails.application.config.assets.precompile += %w( refinerycms-videojs-admin.css wymeditor_monkeypatch.js )

