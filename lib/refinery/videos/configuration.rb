module Refinery
  module Videos
    extend Refinery::Dragonfly::ExtensionConfiguration
    include ActiveSupport::Configurable

    config_accessor :max_file_size, 
                    :pages_per_dialog, 
                    :pages_per_admin_index,
                    :whitelisted_mime_types,
                    :skin_css_class
    
    self.max_file_size = 524_288_000
    self.pages_per_dialog = 7
    self.pages_per_admin_index = 20
    self.whitelisted_mime_types = %w(video/mp4 video/x-flv application/ogg video/webm video/flv video/ogg)
    self.skin_css_class = "vjs-default-skin"
  end
end
