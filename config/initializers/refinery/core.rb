Refinery::Core.configure do |config|
  # Register extra javascript for backend
  config.register_javascript "refinery/admin/refinerycms-videojs-admin.js"

  # Register extra stylesheet for backend (optional options)
  config.register_stylesheet "refinery/admin/refinerycms-videojs-admin.css",:media => 'screen'
end
#  config/initializers/assets.rb adds these files to the asset pipeline
