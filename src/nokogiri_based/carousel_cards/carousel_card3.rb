require_relative './carousel_card1'

module NokogiriBased
  module CarouselCards
    # based on dune-actors.html
    class CarouselCard3 < CarouselCard1
      NAME_PATTERN = 'title'
      META_PATTERN = "div.ellip"

      private

        def name; tree[NAME_PATTERN]; end
        def meta; tree.at_css(META_PATTERN)&.text.to_s; end
    end
  end
end