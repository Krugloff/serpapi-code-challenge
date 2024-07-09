require_relative './carousel_card1'

module NokogiriBased
  module CarouselCards
    # based on us-presidents.html it's last .FozYP div 
    # unfortunately colorado-cities.html cards contains name inside .FozYP element
    # so we can't simple use this class or last div
    # there is a two ways I see:
    # we can check that name doesn't equal meta
    # or we can use a['title'] - a['aria-label']
    class CarouselCard2 < CarouselCard1
      # META_PATTERN = "div.FozYP"

      # private def meta = tree.css(META_PATTERN).last&.text
    end
  end
end