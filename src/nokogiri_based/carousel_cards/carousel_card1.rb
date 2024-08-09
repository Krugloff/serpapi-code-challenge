# because links will be parsed as encoded
require 'cgi'

module NokogiriBased
  module CarouselCards
    # based on van-gogh-paintings.html
    class CarouselCard1
      DOMAIN = "https://www.google.com"

      NAME_PATTERN = 'aria-label'
      HREF_PATTERN = 'href'
      TITLE_PATTERN = 'title'
      # based on dune-actors.html there is no g-img anymore
      THUMBNAIL_PATTERN = 'img'
      # approach based on 'title - label' is more general
      # META_PATTERN = "div.klmeta"

      attr_reader :tree, :thumbnails_map

      def initialize(tree, thumbnails_map)
        @tree = tree
        @thumbnails_map = thumbnails_map
      end

      # TODO: return empty result if name or link was not found
      def to_h; value; end

      private

        def value; { name: name, link: link, image: image }.merge(extensions); end
        def name; tree[NAME_PATTERN]; end
        def link; CGI.unescapeHTML(DOMAIN + tree[HREF_PATTERN]); end
        def title; tree[TITLE_PATTERN]; end
        # based on us-presidents.html there is no images sometimes
        def image; thumbnails_map[thumbnail_id]; end
        def thumbnail_id; tree.at_css(THUMBNAIL_PATTERN).to_h['id']; end
        def meta; title.to_s.sub(name, '').gsub(/[\(\)]/, ''); end
        def extensions; meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h; end
    end
  end
end