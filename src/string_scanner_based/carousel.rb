require 'strscan'
require_relative './thumbnails_map.rb'
require_relative './carousel_cards.rb'
require_relative './element_not_found.rb'
require_relative './sub_str.rb'

module StringScannerBased
  class Carousel
    BLOCK_OPEN_PATTERN = /<g-scrolling-carousel/
    BLOCK_CLOSE_PATTERN = /<\/g-scrolling-carousel/

    CARD_VARIANTS = {
      /<a[^>]*?class="klitem"/ => CarouselCards::CarouselCard1,
      /<a[^>]*?class=".*?klitem-tr.*?"/ => CarouselCards::CarouselCard2,
      /<div[^>]*?role="listitem"[^>]*?><a/ => CarouselCards::CarouselCard3
    }

    CARD_CLOSE_PATTERN = /<\/a>/

    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    # so each CarouselCard moves the scanner pointer
    def to_a; enum.take_while(&:any?); end

    private

      def enum
        Enumerator.produce do
          carousel_scanner.skip_until(variant.first) || raise(StopIteration)
          card
        end
      end

      def body; SubStr[scanner, BLOCK_OPEN_PATTERN, BLOCK_CLOSE_PATTERN].to_s; end

      def thumbnails_map
        @thumbnails_map ||= ThumbnailsMap.new(scanner).to_h
      end

      def variant
        @variant ||= CARD_VARIANTS
          .find { |pattern, klass| carousel_scanner.skip_until(pattern) }
          .tap { raise(ElementNotFound.new('Valid Card Variant')) unless _1 }
          # hack to not miss the first link
          .tap { carousel_scanner.unscan }
      end

      # should not be cached since each send will move the scanner pointer
      # there is img without id, links without img and links without meta info sometimes...
      # so I don't want scan until next link
      def card; variant.last.new(StringScanner.new(card_html), thumbnails_map).to_h; end
      def card_html; carousel_scanner.scan_until(CARD_CLOSE_PATTERN); end

      def carousel_scanner
        @carousel_scanner ||= StringScanner.new(body)
      end
  end

  private_constant :Carousel
end