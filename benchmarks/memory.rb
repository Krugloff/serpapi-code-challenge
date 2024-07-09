require 'memory_profiler'
require_relative '../src/regexp_based/knowledge_graph'
require_relative '../src/nokogiri_based/knowledge_graph'
require_relative '../src/nokolexbor_based/knowledge_graph'
require_relative '../src/string_scanner_based/knowledge_graph'

html = File.read('./files/van-gogh-paintings.html')

def run_bencmark(html)
  namespaces = {
    RegexpBased => true,
    NokogiriBased => true,
    NokolexborBased => true,
    StringScannerBased => true
  }

  namespaces.each do |namespace, flag|
    next unless flag
    
    MemoryProfiler
      .report { namespace::KnowledgeGraph.new(html).to_h rescue nil }
      .then { puts "#{namespace.name}: #{_1.total_allocated_memsize}" }
  end
end

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

# It's useful to check how much time we need to fail so I remove some chars from carousel tag.
# for example Nokogiri and Nokolexbor will spend time to build html tree
# even without correct variants
puts "UNKNOWN VARIANT" 
run_bencmark File.read('./files/unknown-variant.html')

# My results:
# FIRST VARIANT
# RegexpBased:        1124140
# NokogiriBased:      1978526
# NokolexborBased:     457532
# StringScannerBased: 1014363

# SECOND VARIANT
# RegexpBased:        1202801
# NokogiriBased:      2309876
# NokolexborBased:     787844
# StringScannerBased: 1169989

# THIRD VARIANT
# RegexpBased:         876304
# NokogiriBased:      2126813
# NokolexborBased:     473569
# StringScannerBased:  788515

# FOURTH VARIANT
# RegexpBased:        1390196
# NokogiriBased:      2479056
# NokolexborBased:     934655
# StringScannerBased: 1396776

# MASONRY VARIANT
# RegexpBased:        1406859
# NokogiriBased:      2670877
# NokolexborBased:     987331
# StringScannerBased: 1455281

# UNKNOWN VARIANT
# RegexpBased:         624062
# NokogiriBased:      1727781
# NokolexborBased:     273668
# StringScannerBased:   13293
