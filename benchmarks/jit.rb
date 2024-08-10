require 'benchmark'
require_relative '../src/regexp_based/knowledge_graph'
require_relative '../src/nokogiri_based/knowledge_graph'
require_relative '../src/nokolexbor_based/knowledge_graph'
require_relative '../src/string_scanner_based/knowledge_graph'

def run_bencmark(html)
  namespaces = [ RegexpBased, NokogiriBased, NokolexborBased, StringScannerBased ]

  namespaces.each do |namespace|
    results = 3.times.map do
      Benchmark
        .realtime { 10_000.times { namespace::KnowledgeGraph.new(html).to_h rescue nil } }
        .round(2)
    end

    puts "#{namespace.name}: #{results.sort.inspect}"
  end
end

run_bencmark File.read('./files/van-gogh-paintings.html');