require_relative './thumbnails_map.rb'
require_relative './masonry_card.rb'
require_relative './element_not_found.rb'

module RegexpBased
  class Masonry
    # ok, it's not so good but I try it only for benchmarking
    ELEMENT_PATTERN = /<a[^>]*?><img[^>]*?><div.*?<\/a>/

    attr_reader :html

    def initialize(html)
      @html = html
    end

    def to_a; cards.tap { raise(ElementNotFound.new('MasonryCard')) if _1.empty? }; end

    private

      def thumbnails_map
        @thumbnails_map ||= ThumbnailsMap.new(html).to_h
      end

      def cards; html.scan(ELEMENT_PATTERN).map { MasonryCard.new(_1, thumbnails_map).to_h }; end
  end

  private_constant :Masonry
end