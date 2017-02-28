require 'dragonfly'

module Refinery
  module Videos
    class Video < Refinery::Core::BaseModel
    include ActionView::Helpers::TagHelper

      self.table_name = 'refinery_videos'
      acts_as_indexed :fields => [:title]

      validates :title, :presence => true
      validate :one_source

      has_many :video_files, :dependent => :destroy
      accepts_nested_attributes_for :video_files

      belongs_to :poster, :class_name => '::Refinery::Image'
      accepts_nested_attributes_for :poster

      ################## Video config options
      serialize :config, Hash
      CONFIG_OPTIONS = {
          :autoplay => "false", :width => "400", :height => "300",
          :controls => "true", :preload => "true", :loop => "true"
      }

      # Create getters and setters
      CONFIG_OPTIONS.keys.each do |option|
        define_method option do
          self.config[option]
        end
        define_method "#{option}=" do |value|
          self.config[option] = value
        end
      end
      #######################################

      ########################### Callbacks
      after_initialize :set_default_config
      #####################################

      def to_html
        if use_shared
          update_from_config
          return embed_tag.html_safe
        end

        data_setup =  {}
        ::Refinery::Videos::Video::CONFIG_OPTIONS.keys.reject{|opt| [:height, :width].include?(opt)}.each do |option|
          data_setup[option] = config[option] || 'auto'
        end

        data_setup.merge(poster: poster.url) if poster

        options = {
          id: "video_#{id}",
          class: "video-js #{Refinery::Videos.skin_css_class}",
          width: config[:width],
          height: config[:height],
          :"data-setup" => data_setup.to_json,
          poster: '' || poster.url
        }

        content_tag(:video, sources_html, options, escape: false)
      end

      def sources_html
        video_files.each.inject(ActiveSupport::SafeBuffer.new) do |buffer, file|
          options = {
            src: file.use_external ? file.external_url : file.url,
            type: file.mime_type || file.file_mime_type

          }
          source = tag(:source, options, escape: false )
          buffer  << source if file.exist?
        end
      end

      def short_info
          return [['.shared_source', embed_tag.scan(/src=".+?"/).first]] if use_shared
          info = []
          video_files.each do |file|
            info << file.short_info
          end
          info
      end

      def embed_source
        embed_tag[/src="\b(\S*)\b"/, 1]
      end

      ####################################class methods
      class << self
        def per_page(dialog = false)
          dialog ? Videos.pages_per_dialog : Videos.pages_per_admin_index
        end
      end
      #################################################

      private

      def set_default_config
        if new_record? && config.empty?
          CONFIG_OPTIONS.each do |option, value|
            self.send("#{option}=", value)
          end
        end
      end

      def update_from_config
        embed_tag.gsub!(/width="(\d*)?"/, "width=\"#{config[:width]}\"")
        embed_tag.gsub!(/height="(\d*)?"/, "height=\"#{config[:height]}\"")
        #fix iframe overlay
        if embed_tag.include? 'iframe'
          embed_tag =~ /src="(\S+)"/
          embed_tag.gsub!(/src="\S+"/, "src=\"#{$1}?wmode=transparent\"")
        end
      end

      def one_source
        errors.add(:embed_tag, 'Please embed a video') if use_shared && embed_tag.nil?
        errors.add(:video_files, 'Please select at least one source') if !use_shared && video_files.empty?
      end

    end

  end
end
