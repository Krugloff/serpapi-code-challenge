require 'rspec'
require_relative '../dummy_knowledge_graph'

RSpec.describe Dummy::KnowledgeGraph do
  [
    'van-gogh-paintings-expected-array',
    'us-presidents-expected-array',
    'dune-actors-expected-array',
    'colorado-cities-expected-array',
    'van-gogh-paintings-masonry-expected-array'
  ].each do |name|
    context "when file is #{name}" do
      let(:graph) { described_class.new("./files/#{name}.json") }

      describe '#to_h' do
        subject { graph.to_h }

        # actually I guess that's better to return empty extensions instead "no key"
        it 'returns expected format' do
          artworks = subject[:artworks]

          expect(artworks).to_not be_empty

          # ruby pattern matching version
          # expect(artworks.all? do
          #   _1 in
          #     { name: String, link: String, image: String | nil, extensions: [String] } |
          #     { name: String, link: String, image: String | nil }
          # end).to be_truthy

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
end