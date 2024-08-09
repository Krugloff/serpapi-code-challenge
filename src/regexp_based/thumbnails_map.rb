require_relative './element_not_found.rb'

module RegexpBased
  class ThumbnailsMap
    # (function(){var s='<image>';var ii=['kximg0'];
    # (function(){var s='(?<image>)';var ii=['(?<id>)'];
    ELEMENT_PATTERN = /\(function\(\){var s='(?<image>[^']+?)';var ii=\['(?<id>[^']+?)'\];/m

    attr_reader :html

    def initialize(html)
      @html = html
    end

    # van-gogh-paintings.html contains one big script
    # other variant contains few small scripts
    # that's interesting that without searching main script
    # it's working for all cases and working 2-3 times faster
    def to_h
      html
        .scan(ELEMENT_PATTERN)
        .tap { raise(ElementNotFound.new(self.class.name)) if _1.empty? }
        .each_with_object({}) { |(blob, id), rslt| rslt[id] = blob.gsub('\\', '') }
    end
  end

  private_constant :ThumbnailsMap
end