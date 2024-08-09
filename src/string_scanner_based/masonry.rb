require 'strscan'
require_relative './thumbnails_map.rb'
require_relative './masonry_card.rb'
require_relative './sub_str.rb'
require_relative './element_not_found.rb'

module StringScannerBased
  class Masonry
    # ok, it's not so good but I try it only for benchmarking
    # of course we can use generated class .Cz5hV > .iELo6 but
    # I don't know how long they will exists
    # I guess it is possible with the any "daily basis checks" system.
    BLOCK_OPEN_PATTERN = /<div[^>]*?data-attrid="[^"]*?kc:[^"]*?"[^>]*>/
    BLOCK_CLOSE_PATTERN = /<g-more-link/ # TODO: try to use for RegexpBased?

    ELEMENT_OPEN_PATTERN = /<a/
    ELEMENT_CLOSE_PATTERN = /<\/a/

    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    def to_a; cards.tap { raise(ElementNotFound.new('MasonryCard')) if _1.empty? }; end

    private

      def thumbnails_map
        @thumbnails_map ||= ThumbnailsMap.new(scanner).to_h
      end

      def body; SubStr[scanner, BLOCK_OPEN_PATTERN, BLOCK_CLOSE_PATTERN].to_s; end

      def masonry_scanner
        @masonry_scanner ||= StringScanner.new(body)
      end

      def enum
        Enumerator.produce do
          masonry_scanner.skip_until(ELEMENT_OPEN_PATTERN) || raise(StopIteration)
          masonry_scanner.scan_until(ELEMENT_CLOSE_PATTERN)
        end
      end

      def cards; enum.map { MasonryCard.new(StringScanner.new(_1), thumbnails_map).to_h }; end
  end

  private_constant :Masonry
end
