require 'nokogiri'
require_relative './carousel.rb'
require_relative './masonry.rb'
require_relative './element_not_found.rb'

module NokogiriBased
  class KnowledgeGraph
    attr_reader :html

    def initialize(html)
      @html = html
    end

    def to_h; { artworks: required_artworks }; end

    private

      def required_artworks; artworks.find(&:any?) || raise(ElementNotFound.new('Artworks')); end

      def artworks
        tree.then { |t| [Carousel, Masonry].lazy.map { _1.new(t) } }.map do
          _1.to_a
        rescue ElementNotFound
          []
        end
      end

      def tree; Nokogiri::HTML(html); end
  end
end