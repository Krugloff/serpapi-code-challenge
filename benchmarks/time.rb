require 'benchmark'
require_relative '../src/regexp_based/knowledge_graph'
require_relative '../src/nokogiri_based/knowledge_graph'
require_relative '../src/nokolexbor_based/knowledge_graph'
require_relative '../src/string_scanner_based/knowledge_graph'

def run_bencmark(html)
  namespaces = {
    RegexpBased => true,
    NokogiriBased => true,
    NokolexborBased => true,
    StringScannerBased => true
  }

  namespaces.each do |namespace, flag|
    next unless flag
    
    counter = 0
    code = -> { namespace::KnowledgeGraph.new(html).to_h rescue nil }

    results = 5.times.map do 
      Benchmark.realtime { 1000.times { code.call.tap { counter = _1.to_h[:artworks].to_a.size } } }
    end
    
    average_time = (results.sum / results.size).round(2)
    
    puts "#{namespace.name}: #{average_time} - #{counter} entries"
  end
end

# I tried run this in a three Ractors but Nokogiri doesn't work :)
puts "FIRST VARIANT"
run_bencmark File.read('./files/van-gogh-paintings.html')

puts "SECOND VARIANT"
run_bencmark File.read('./files/us-presidents.html')

puts "THIRD VARIANT"
run_bencmark File.read('./files/dune-actors.html')

puts "FOURTH VARIANT"
run_bencmark File.read('./files/colorado-cities.html')

puts "MASONRY VARIANT"
run_bencmark File.read('./files/van-gogh-paintings-masonry.html')

puts "UNKNOWN VARIANT" 
run_bencmark File.read('./files/unknown-variant.html')