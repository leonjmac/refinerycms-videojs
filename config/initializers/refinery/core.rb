Refinery::Core.configure do |config|
	# Register extra javascript for backend
  config.register_javascript "refinery/admin/wymeditor_monkeypatch"

	# Register extra stylesheet for backend
  config.register_stylesheet "refinery/admin/refinerycms-videojs-admin", :media => 'screen'
end

Rails.application.config.assets.precompile += %w( refinerycms-videojs-admin.css wymeditor_monkeypatch.js )

Refinery::Wymeditor.configure do |config|

# Add extra tags to the wymeditor whitelist e.g. = {'tag'=> {'attributes'=> {'1'=> 'href'}}} or just {'tag'=> {}}
# config.whitelist_tags =  {'span'=> {
# 'attributes'=> {
# '1'=> 'data-tooltip'
# }}}
  config.whitelist_tags =
  {'video' => {
    'attributes'=> {
      '0'=> 'width',
      '1'=> 'height',
      '2'=> 'poster',
      '3'=> 'data-setup'
    }
  },
  'source'=> {
    'attributes'=> {
      '0'=> 'src',
      '1'=> 'type'
    }
  }
}
end