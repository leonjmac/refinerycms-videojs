module Refinery
  module Videos
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_videos

      initializer 'attach-refinery-videos-with-dragonfly', before: :finisher_hook do |app|
        ::Refinery::Videos::Dragonfly.configure!(::Refinery::Videos)
        ::Refinery::Videos::Dragonfly.attach!(app, ::Refinery::Videos)
      end

     before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_videos'
          plugin.menu_match = %r{refinery/videos/video(_dialog)?s$}
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.videos_admin_videos_path }
          #plugin.always_allow_access = true
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Videos)
      end

    end
  end
end
