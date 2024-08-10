# because links will be parsed as encoded
require 'cgi'

module NokogiriBased
  # based on van-gogh-paintings-masonry.html
  class MasonryCard
    DOMAIN = "https://www.google.com"

    HREF_PATTERN = 'href'
    THUMBNAIL_PATTERN = 'img'
    NAME_PATTERN = 'alt'
    META_PATTERN = "div"

    attr_reader :tree, :thumbnails_map

    def initialize(tree, thumbnails_map)
      @tree = tree
      @thumbnails_map = thumbnails_map
    end

    def to_h; value; end

    private

      def value; { name: name, link: link, image: image}.merge(extensions); end
      def link; CGI.unescapeHTML(DOMAIN + tree[HREF_PATTERN]); end
      def img; @img ||= tree.at_css(THUMBNAIL_PATTERN); end
      def name; img[NAME_PATTERN]; end
      def image; thumbnails_map[img['id']]; end

      # last div can contains nothing
      def meta; tree.css(META_PATTERN).last&.text.to_s; end
      def extensions; meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h; end
  end

  private_constant :MasonryCard
end