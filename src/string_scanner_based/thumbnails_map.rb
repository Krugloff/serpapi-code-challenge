require 'strscan'
require_relative './element_not_found.rb'

module StringScannerBased
  # I guess this search will work for all variants
  class ThumbnailsMap
    IMAGE_OPEN_PATTERN = /\(function\(\){var s='/
    ID_OPEN_PATTERN = /;var ii=\['/
    ELEMENT_CLOSE_PATTERN = /'/

    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    def to_h; enum.to_h.tap { raise ElementNotFound.new('ThumbnailsMap') if _1.empty? }; end

    private

      def enum
        StringScanner.new(scanner.rest).then do |t_scanner|
          Enumerator.produce do
            # it is possible to use scanner.scan(/[^']+/) for scanning before `'`
            # surprisly current version is faster
            blob = SubStr[t_scanner, IMAGE_OPEN_PATTERN, ELEMENT_CLOSE_PATTERN]
              .delete_suffix(?')

            id = SubStr[t_scanner, ID_OPEN_PATTERN, ELEMENT_CLOSE_PATTERN]
              .delete_suffix(?')

            # TODO:
            # for some reasons expected-array
            # contains 2Qx3dx3d instead 2Q\x3d\x3d
            # i'm not sure I should do the same
            [id, blob.gsub('\\', '')]
          rescue ElementNotFound
            raise StopIteration
          end
        end
      end
  end

  private_constant :ThumbnailsMap
end