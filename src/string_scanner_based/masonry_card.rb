# because links will be parsed as encoded
require 'cgi'

module StringScannerBased
  # unfortunately in this variant attributes should be exactly in the same order
  class MasonryCard
    DOMAIN = "https://www.google.com"

    HREF_PATTERN = /[^>]*?href="(?<link>[^"]+?)".*?>/
    NAME_PATTERN = /<img[^>]*?alt="(?<name>[^"]+?)"/

    THUMBNAIL_ID_PATTERN = /[^>]*?id="(?<id>[^"]+?)"[^>]*?>/

    # contains of last div
    META_PATTERN = />(?<meta>[^<]*?)(<\/div>)*?<\/a/

    attr_reader :scanner, :thumbnails_map

    def initialize(scanner, thumbnails_map)
      @scanner = scanner
      @thumbnails_map = thumbnails_map
    end

    def to_h; attrs_html ? value : {}; end

    private

      # order is imprtant!
      def value; { link: link, name: name, image: image}.merge(extensions); end

      def attrs_html; scanner.scan_until(HREF_PATTERN); end
      def link; CGI.unescapeHTML(DOMAIN + scanner[:link]); end
      def name; scanner.skip_until(NAME_PATTERN).then { scanner[:name] }; end
      def image; thumbnails_map[thumbnail_id]; end
      def thumbnail_id; scanner.skip_until(THUMBNAIL_ID_PATTERN).then { scanner[:id] }; end

      # last div can contains nothing
      def meta; scanner.skip_until(META_PATTERN).then { scanner[:meta].to_s }; end
      def extensions; meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h; end
  end
end