require_relative './thumbnails_map.rb'
require_relative './carousel_cards.rb'
require_relative './element_not_found.rb'

module RegexpBased
  class Carousel
    # for some reasons w/o `m` flag it's working 5 times slow
    BLOCK_PATTERN = /<g-scrolling-carousel.*?>(?<carousel>.+?)<\/g-scrolling-carousel>/m

    # it is better to choose varinat based on <a class> than check wrong meta for each card
    # based on us-presidents.html class can be klitem
    # based on dune-actors.html class can be generated
    # but it's always a link
    CARD_VARIANTS = {
      /<a[^>]*?class="klitem".*?>.*?<\/a>/ => CarouselCards::CarouselCard1,
      /<a[^>]*?class=".*?klitem-tr.*?".*?>.*?<\/a>/ => CarouselCards::CarouselCard2,
      /<div[^>]*?role="listitem".*?><a.*?>.*?<\/a>/ => CarouselCards::CarouselCard3
    }

    private attr_reader :html

    def initialize(html)
      @html = html
    end

    def to_a = variant || raise(ElementNotFound.new('Valid Card Variant'))

    private

      def thumbnails_map 
        @thumbnails_map ||= ThumbnailsMap.new(html).to_h
      end

      def variant
        CARD_VARIANTS.lazy
          .map { |pttrn, klass| block_html.scan(pttrn).map { klass.new(_1, thumbnails_map).to_h } }
          .find(&:any?)
      end

      def block_html
        @block_html ||= BLOCK_PATTERN.then { html.slice(_1, 1) || raise(ElementNotFound.new(_1)) }
      end
  end

  private_constant :Carousel
end