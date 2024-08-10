require_relative './element_not_found.rb'

module NokogiriBased
  class ThumbnailsMap
    BLOCK_PATTERN = './/script[contains(text(), "function _setImagesSrc")]'
    ELEMENT_PATTERN = /\(function\(\){var s='(?<blob>.+?)';var ii=\['(?<id>.+?)'\];/

    # based on van-gogh-paintings.html
    # I tried to use data to economy strings on the initializator >.<
    # unfortuantely it's means I can't use constants inside
    Variant1 = Struct.new(:tree) do
      # <script nonce="lOsRZRlq+Dr1LlZhVtLxFg==">function _setImagesSrc...
      # searching by text is a bit slow so maybe it will be better to find all script nodes
      # and then .find { _1.include?("function _setImagesSrc") }
      def to_h
        tree.at(BLOCK_PATTERN)&.text.to_s
          .scan(ELEMENT_PATTERN)
          .each_with_object({}) { |(blob, id), rslt| rslt[id] = blob.gsub('\\', '') }
      end
    end

    # based on us-president.html
    Variant2 = Struct.new(:tree) do
      def to_h
        tree.xpath('.//script').each_with_object({}) do |script, result|
          match = script.text.match(ELEMENT_PATTERN)
          next unless match
          result[match[:id]] = match[:blob].gsub('\\', '')
        end
      end
    end

    attr_reader :tree

    def initialize(tree)
      @tree = tree
    end

    def to_h; variant || raise(ElementNotFound.new('ThumbnailsMap')); end

    private

      def variant; [Variant1, Variant2].lazy.map { _1[tree] }.map(&:to_h).find(&:any?); end
  end

  private_constant :ThumbnailsMap
end