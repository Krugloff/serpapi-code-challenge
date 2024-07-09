require 'strscan'
require_relative './carousel.rb'
require_relative './masonry.rb'
require_relative './element_not_found.rb'

# this is fast but raises headache
# Carousel move scanner pointer to the end of carousel tag and keep scanned html block
# Carousel iterates scanned block with a ThumbnailsMap object that keeps link to the scanner
# ThumbnailMap lazy start scanning from pointer moved by Carousel
module StringScannerBased
  class KnowledgeGraph
    private attr_reader :html

    def initialize(html)
      @html = html
    end

    def to_h = { artworks: required_artworks }

    private
   
      def required_artworks = artworks.find(&:any?) || raise(ElementNotFound.new('Artworks'))

      def artworks 
        [Carousel, Masonry].lazy.map do 
          _1.new(scanner).to_a
        rescue ElementNotFound
          []
        end
      end

      def scanner = StringScanner.new(html)
  end
end