require 'refinerycms-core'
require 'refinerycms-dragonfly'

module Refinery
  autoload :VideosGenerator, 'generators/refinery/videos_generator'

  module Videos
    require 'refinery/videos/engine'
    require 'refinery/dragonfly/extension_configuration'
    require 'refinery/videos/configuration'
    autoload :Validators, 'refinery/videos/validators'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  require 'mobility'
end
