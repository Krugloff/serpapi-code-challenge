require_relative './thumbnails_map.rb'
require_relative './masonry_card.rb'
require_relative './element_not_found.rb'

module NokogiriBased
  class Masonry
    # ok, it's not so good but I try it only for benchmarks
    BLOCK_PATTERN = 'div[data-attrid*="kc:"]'
    ELEMENT_PATTERN = 'a'

    attr_reader :tree

    def initialize(tree)
      @tree = tree
    end

    def to_a; cards.tap { raise(ElementNotFound.new('MasonryCard')) if _1.empty? }; end

    private

      def thumbnails_map
        @thumbnails_map ||= ThumbnailsMap.new(tree).to_h
      end

      def cards; subtree.css(ELEMENT_PATTERN).map { MasonryCard.new(_1, thumbnails_map).to_h }; end
      def subtree; BLOCK_PATTERN.then { tree.at_css(_1) || raise(ElementNotFound.new(_1)) }; end
  end

  private_constant :Masonry
end