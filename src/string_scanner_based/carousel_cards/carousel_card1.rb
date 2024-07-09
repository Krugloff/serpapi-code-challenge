# because links will be parsed as encoded
require 'cgi'

module StringScannerBased
  module CarouselCards
    class CarouselCard1
      DOMAIN = "https://www.google.com"

      # unfortunately in this variant attributes should be exactly in the same order
      LINK_OPEN_PATTERN = %r/
        aria-label="(?<name>.+?)".*?
        href="(?<link>.+?)".*?
        title="(?<title>.+?)".*?
        >
      /x

      THUMBNAIL_ID_PATTERN = /<img[^>]*?id="(?<id>.+?)".*?>/
      # approach based on 'title - label' is more general
      # META_PATTERN = /<div class=".*?klmeta.*?">(?<meta>.+?)<\/div>/

      private attr_reader :scanner, :thumbnails_map

      def initialize(scanner, thumbnails_map)
        @scanner = scanner
        @thumbnails_map = thumbnails_map
      end

      def to_h = attrs_html ? value : {}

      private
        # order is important!
        def value = { name:, link: }.merge!(extensions).merge!(image:)

        # TODO: this hack for child classes can be refactored I hope
        def attrs_html = scanner.scan_until(self.class::LINK_OPEN_PATTERN) 
        def name = scanner[:name]
        def link = CGI.unescapeHTML(DOMAIN + scanner[:link])
        def image = thumbnails_map[thumbnail_id]
        def thumbnail_id = scanner.skip_until(THUMBNAIL_ID_PATTERN).then { scanner[:id] }

        def extensions
          scanner[:title].to_s.sub(name, '').gsub(/[\(\)]/, '')
            .then { { extensions: [_1.strip] } unless _1.empty? }
            .to_h
        end
    end
  end
end