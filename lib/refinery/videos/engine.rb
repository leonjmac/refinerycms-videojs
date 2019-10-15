module Refinery
  module Videos
    class Engine < Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_videos

      config.autoload_paths += %W( #{config.root}/lib )
      
      initializer 'attach-refinery-videos-with-dragonfly', before: :finisher_hook do |app|
        ::Refinery::Dragonfly.configure!(::Refinery::Videos)
        ::Refinery::Dragonfly.attach!(app, ::Refinery::Videos)
      end

     before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_videos'
          plugin.menu_match = %r{refinery/videos/video(_dialog)?s$}
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_videos_path }
          #plugin.always_allow_access = true
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Videos)
      end

    end
  end
end
