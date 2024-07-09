require 'rspec'
require_relative '../dummy_knowledge_graph'
require_relative '../src/regexp_based/knowledge_graph'
require_relative '../src/nokogiri_based/knowledge_graph'
require_relative '../src/nokolexbor_based/knowledge_graph'
require_relative '../src/string_scanner_based/knowledge_graph'

# because I don't want read file for each case :)
files = [
  'van-gogh-paintings',
  'us-presidents',
  'dune-actors',
  'colorado-cities',
  'van-gogh-paintings-masonry'
].each_with_object({}) { |name, result| result[name] = File.read("./files/#{name}.html") }

DUMMY_HTML = <<~HTM.gsub("\n\n", '').gsub("\n", ' ').squeeze(' ').gsub('> <', '><')
  <g-scrolling-carousel>
    <a 
      class="klitem"
      aria-label="The Starry Night" 
      href="/search?something" 
      title="The Starry Night (1889)">
      <g-img><img id="kximg0"></g-img>
    </a>

    <a 
      class="klitem"
      aria-label="Sunflowers"
      href="/search?something"
      title="Sunflowers">
      <g-img><img id="kximg2"></g-img>
    </a>
  </g-scrolling-carousel>

  <script>function _setImagesSrc(function(){var s='blob';var ii=['kximg0'];</script>
HTM

# it is not standard spec per file of course
[NokogiriBased, NokolexborBased, RegexpBased, StringScannerBased].each do |namespace|
  # heh, nobody likes shared examples :)
  RSpec.describe namespace::KnowledgeGraph do
    files.each do |name, html|
      context "when file is #{name}" do
        let(:graph) { described_class.new(html).to_h }

        let(:expected_result) do 
          Dummy::KnowledgeGraph.new("./files/#{name}-expected-array.json").to_h
        end

        describe '#to_h' do
          it { expect(graph).to be_eql(expected_result) }

          # TODO: actually I guess that's better to return empty extensions instead "no key"
          it 'returns expected format' do
            artworks = graph[:artworks]
            
            expect(artworks).to_not be_empty

            # ruby pattern matching version
            expect(artworks.all? do
              _1 in
                { name: String, link: String, image: String | nil, extensions: [String] } |
                { name: String, link: String, image: String | nil } 
            end).to be_truthy

            # rspec matchers version
            artworks.each do |artwork|
              expect(artwork).to match({
                name: a_kind_of(String),
                link: a_kind_of(String),
                image: a_kind_of(String).or(be_nil),
                extensions: [a_kind_of(String)]
              }).or(match({
                name: a_kind_of(String),
                link: a_kind_of(String),
                image: a_kind_of(String).or(be_nil)
              }))
            end
          end
        end
      end
    end

    describe 'issues' do
      let(:graph) { described_class.new(dummy_html).to_h }

      context 'with the correct input' do
        let(:dummy_html) { DUMMY_HTML }

        let(:dummy_result) do
          [
            {
              name: "The Starry Night",
              link: "https://www.google.com/search?something",
              image: "blob",
              extensions: ["1889"]
            },
            {
              name: "Sunflowers",
              link: "https://www.google.com/search?something",
              image: nil
            }
          ]
        end

      
        it { expect(graph[:artworks]).to eq(dummy_result) }
      end

      context 'w/o carousel' do
        let(:dummy_html) { DUMMY_HTML.gsub('g-scrolling-carousel', 'g-scroling-carousel') }

        it { expect{graph[:artworks]}.to raise_error(namespace::ElementNotFound) }
      end   
      
      context 'w/o thumbnails block' do
        let(:dummy_html) { DUMMY_HTML.gsub(/<script[^>]*?>[^<]*?<\/script>/, '') }

        it { expect{graph[:artworks]}.to raise_error(namespace::ElementNotFound) }
      end 

      # # TODO:
      # xcontext 'w/o correct thumbnails blobs' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end 

      # # TODO:
      # xcontext 'w/o correct thumbnails ids' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end 

      # # TODO:
      # xcontext 'w/o correct links classes' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end

      # # TODO:
      # xcontext 'w/o correct link labels' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end 

      # # TODO:
      # xcontext 'w/o correct link hrefs' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end 

      # # TODO:
      # xcontext 'w/o correct link attrs order' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end 

      # # TODO:
      # xcontext 'w/o correct images' do
      #   it { expect{graph[:artworks]}.to eq([]) } #raise_error(namespace::ElementNotFound) }
      # end
    end 
  end
end