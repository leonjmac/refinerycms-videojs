Refinery::Core.configure do |config|
  # Register extra javascript for backend
  config.register_javascript "refinerycms-videojs-admin"

  # Register extra stylesheet for backend (optional options)
  config.register_stylesheet "refinerycms-videojs-admin", :media => 'screen'
end
#  config/initializers/assets.rb adds these files to the asset pipeline
