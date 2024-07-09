require_relative './carousel_card1'

module RegexpBased
  module CarouselCards
    # based on us-presidents.html it's last .FozYP div 
    # unfortunately colorado-cities.html cards contains name inside .FozYP element
    # so we can't simple use this class or last div
    # there is a two ways I see:
    # we can check that name doesn't equal meta
    # or we can use a['title'] - a['aria-label']
    class CarouselCard2 < CarouselCard1
      # META_PATTERN = /<div class=".*?FozYP.*?">(?<meta>.+?)<\/div>/

      # ok first last will return array since there is a named group
      # private def meta = html.scan(META_PATTERN).last&.last
    end
  end
end