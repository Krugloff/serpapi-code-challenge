require 'json'

# ok file naming is not standard just for comfort
module Dummy
  class KnowledgeGraph
    private attr_reader :path
    
    def initialize(path = './files/van-gogh-paintings-expected-array.json')
      @path = path
    end

    def to_h = parsed_json

    private

      def json = File.read(path)
      def parsed_json = JSON.parse(json, symbolize_names: true)
  end
end