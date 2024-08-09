require 'nokolexbor'
require_relative '../nokogiri_based/knowledge_graph.rb'
require_relative '../nokogiri_based/element_not_found.rb'

module NokolexborBased
  ElementNotFound = Class.new(StandardError)

  class KnowledgeGraph < NokogiriBased::KnowledgeGraph
    def to_h
      super
    rescue NokogiriBased::ElementNotFound => e # just a hack for specs
      raise ElementNotFound.new(e.message)
    end

    private

      def tree; Nokolexbor::HTML(html); end
  end
end