require_relative './carousel_card1'

module StringScannerBased
  module CarouselCards
    class CarouselCard2 < CarouselCard1
      # unfortunately the order of attrs is very important
      LINK_OPEN_PATTERN = %r/
        href="(?<link>.+?)"[^>]*?
        title="(?<title>.+?)"[^>]*?
        aria-label="(?<name>.+?)"
      /x

      # based on us-presidents.html it's last .FozYP div 
      # unfortunately colorado-cities.html cards contains name inside .FozYP element
      # so we can't simple use this class or last div
      # there is a two ways I see:
      # we can check that name doesn't equal meta
      # or we can use a['title'] - a['aria-label']
      # META_PATTERN = /<div class=".*?FozYP.*?">(?<meta>.+?)<\/div>/

      private

        # regexp since it's a bit difficult to scan
        # def meta = scanner.rest.scan(META_PATTERN).last&.last 
    end
  end
end