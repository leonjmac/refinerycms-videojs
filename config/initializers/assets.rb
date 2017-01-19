Rails.application.config.assets.precompile += %w( refinerycms-videojs-admin.css wymeditor-monkeypatch.js )
Rails.application.config.assets.precompile += [/\.(?:svg)\z/]
