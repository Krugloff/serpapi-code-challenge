# because links will be parsed as encoded
require 'cgi'

module RegexpBased
  module CarouselCards
    class CarouselCard1
      DOMAIN = "https://www.google.com"

      NAME_PATTERN = /<a[^>]*?aria-label="(?<name>.+?)"/
      HREF_PATTERN = /<a[^>]*?href="(?<link>.+?)"/
      TITLE_PATTERN = /<a[^>]*?title="(?<title>.+?)"/
      THUMBNAIL_ID_PATTERN = /<img[^>]*?id="(?<id>.+?)"/
      # approach based on 'title - label' is more general
      # META_PATTERN = /<div class=".*?klmeta.*?">(?<meta>.+?)<\/div>/

      attr_reader :html, :thumbnails_map

      def initialize(html, thumbnails_map)
        @html = html
        @thumbnails_map = thumbnails_map
      end

      def to_h; value; end

      private

        def value; { name: name, link: link, image: image }.merge(extensions); end
        def name; html.slice(NAME_PATTERN, 1).to_s; end
        # URI.join("https://www.google.com", _1).to_s maybe better
        def link; CGI.unescapeHTML(DOMAIN + path); end
        def path; html.slice(HREF_PATTERN, 1); end

        # based on us-presidents there is no images sometimes
        def image; thumbnails_map[thumbnail_id]; end
        def thumbnail_id; html.slice(THUMBNAIL_ID_PATTERN, 1); end
        def title; html.slice(TITLE_PATTERN, 1); end
        # todo: cache name?
        def meta; title.to_s.sub(name, '').strip.delete_prefix('(').delete_suffix(')'); end

        def extensions; meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h; end
    end
  end
end