require_relative './carousel.rb'
require_relative './masonry.rb'
require_relative './element_not_found.rb'

module RegexpBased
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
          _1.new(html).to_a
        rescue ElementNotFound
          []
        end
      end
  end
end

