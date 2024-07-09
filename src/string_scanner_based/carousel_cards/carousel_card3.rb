require_relative './carousel_card1'

module StringScannerBased
  module CarouselCards
    # based on dune-actors.html
    class CarouselCard3 < CarouselCard1
      LINK_OPEN_PATTERN = %r/
        title="(?<name>.+?)".*?
        href="(?<link>.+?)".*?>
      /x

      META_PATTERN = /<div class=".*?ellip.*?">(?<meta>.+?)<\/div>/

      private
        # order is important!
        def value = { name:, link:, image: }.merge(extensions)
        # it is important to scan meta after all!
        def extensions = meta.then { { extensions: [_1.strip] } unless _1.empty? }.to_h
        def meta = scanner.skip_until(META_PATTERN).then { scanner[:meta] }
    end
  end
end