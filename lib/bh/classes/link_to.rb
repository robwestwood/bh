require 'bh/classes/base'

module Bh
  module Classes
    class LinkTo < Base
      def initialize(app = nil, *args, &block)
        @url = extract_url_from(*args, &block)
        super
      end

      def current_page?
        case Bh.framework
        when :rails
          @app.current_page? @url
        when :padrino
          request =  @app.request
          request.path_info == @app.url_for(@url)
        when :middleman
          return false if @url.nil?
          url_s = @url.to_s # We expect url to be a string, but just in case
          # The middleman-generated path may or may not end with a slash (depending)
          #  on the setting of set :trailing_slash; in either case @url can be a
          #  user-generated url which may or may not end in the way that matches
          #  that of middleman-generated paths
          if url_s.end_with?('/')
            url_with_slash = url_s
            url_without_slash = url_s.chomp('/')
          else
            url_without_slash = url_s
            url_with_slash = url_s + '/'
          end
          current_resource_url = @app.url_for(@app.current_resource)
          current_resource_url == @app.url_for(url_with_slash) || current_resource_url == @app.url_for(url_without_slash)
        end
      end

      def content
        super if @content
      end
    end
  end
end
