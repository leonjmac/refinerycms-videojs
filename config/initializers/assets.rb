Rails.application.config.assets.precompile += %w( refinerycms-videojs-admin.css refinerycms-videojs-admin.js )
Rails.application.config.assets.precompile += [/\.(?:svg)\z/]
