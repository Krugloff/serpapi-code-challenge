# because links will be parsed as encoded
require 'cgi'

module RegexpBased
  # based on van-gogh-paintings-masonry.html
  class MasonryCard
    DOMAIN = "https://www.google.com"

    NAME_PATTERN = /<img[^>]*?alt="(?<alt>.+?)"/

    HREF_PATTERN = /<a[^>]*?href="(?<href>.+?)"/
    THUMBNAIL_ID_PATTERN = /<img[^>]*?id="(?<id>[^"]+?)"/
    
    # contains of last div
    META_PATTERN = />(?<meta>[^<]*?)(<\/div>)*?<\/a>/

    # there is no id sometimes, only src.
    IMG_PATTERN = /<img[^>]*?alt="(?<alt>.+?)"([^>]*?id="(?<id>[^"]+?)")?/

    private attr_reader :html, :thumbnails_map

    def initialize(html, thumbnails_map)
      @html = html
      @thumbnails_map = thumbnails_map
    end

    def to_h = value
    
    private

      def value = { name:, link:, image: }.merge(extensions)
      # URI.join("https://www.google.com", _1).to_s maybe better
      def link = CGI.unescapeHTML(DOMAIN + html.slice(HREF_PATTERN, 1))
      def image = thumbnails_map[thumbnail_id]
      # last div can contains nothing
      def meta = html.slice(META_PATTERN, 1).to_s
      def extensions = meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h
      def img = @img ||= html.match(IMG_PATTERN)
      def name = img[:alt]
      def thumbnail_id = img[:id]
  end

  private_constant :MasonryCard
end