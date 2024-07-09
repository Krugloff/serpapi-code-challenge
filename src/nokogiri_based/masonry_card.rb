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

    private attr_reader :tree, :thumbnails_map

    def initialize(tree, thumbnails_map)
      @tree = tree
      @thumbnails_map = thumbnails_map
    end

    def to_h = value

    private 

      def value = { name:, link:, image: }.merge(extensions)
      def link = CGI.unescapeHTML(DOMAIN + tree[HREF_PATTERN])
      def img = @img ||= tree.at_css(THUMBNAIL_PATTERN)
      def name = img[NAME_PATTERN]
      def image = thumbnails_map[img['id']]

      # last div can contains nothing
      def meta = tree.css(META_PATTERN).last&.text.to_s
      def extensions = meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h
  end

  private_constant :MasonryCard
end