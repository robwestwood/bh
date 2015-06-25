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
          
          url = @app.url_for(@url)  # Normalise our input URL in Middleman way
          
          # The middleman-generated path may or may not end with a slash (depending)
          #  on the setting of set :trailing_slash; in either case @url can be a
          #  user-generated url which may or may not end in the way that matches
          #  that of middleman-generated paths
          if url.end_with?('/')
            url_with_slash = url
            url_without_slash = url.chomp('/')
          else
            url_without_slash = url
            url_with_slash = url + '/'
          end
          current_resource_url = @app.url_for(@app.current_resource)
          current_resource_url == url_with_slash || current_resource_url == url_without_slash
        end
      end

      def content
        super if @content
      end
    end
  end
end
