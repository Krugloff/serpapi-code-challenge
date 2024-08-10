require_relative './thumbnails_map.rb'
require_relative './carousel_cards.rb'
require_relative './element_not_found.rb'

module NokogiriBased
  class Carousel
    BLOCK_PATTERN = 'g-scrolling-carousel'

    # it is better to choose varinat based on <a class> than check wrong meta for each card
    # based on us-presidents.html class can be klitem
    # based on dune-actors.html class can be generated
    # but it's always a link
    CARD_VARIANTS = {
      "a.klitem": CarouselCards::CarouselCard1,
      "a.klitem-tr": CarouselCards::CarouselCard2,
      "div[role=\"listitem\"] > a": CarouselCards::CarouselCard3
    }

    attr_reader :tree

    def initialize(tree)
      @tree = tree
    end

    def to_a; variants.find(&:any?) || raise(ElementNotFound.new('Valid Card Variant')); end

    private

      def thumbnails_map
        @thumbnails_map ||= ThumbnailsMap.new(tree).to_h
      end

      def variants
        CARD_VARIANTS.lazy.map do |selector, klass|
          subtree.css(selector).map { klass.new(_1, thumbnails_map).to_h }
        end
      end

      def subtree
        @subtree ||= BLOCK_PATTERN.then { tree.at_css(_1) || raise(ElementNotFound.new(_1)) }
      end
  end

  private_constant :Carousel
end