require_relative './carousel_card1'

module RegexpBased
  module CarouselCards
    # based on dune-actors.html
    class CarouselCard3 < CarouselCard1
      NAME_PATTERN = /<a[^>]*?title="(?<name>.+?)"/
      META_PATTERN = /<div class=".*?ellip.*?">(?<meta>[^<]+?)</

    private

      def name = html.slice(NAME_PATTERN, 1).to_s
      def meta = html.slice(META_PATTERN, 1).to_s
    end
  end
end