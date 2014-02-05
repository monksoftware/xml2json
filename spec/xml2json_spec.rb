require 'rspec/autorun'
require 'xml2json'
require 'json'

def open_fixture_file(name)
  File.read(File.join(Dir.pwd, 'spec', 'fixtures', name))
end

describe XML2JSON do
  it "parses xml into json" do
    xml = '<a><b><c>Hello</c><d>World</d></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "c" => "Hello", "d" => "World" } } })
    )

    xml = '<a><b><x>Io</x><c><d>Hello</d><e>World</e></c></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "x" => "Io", "c" => { "d" => "Hello", "e" => "World" } } } })
    )
  end

  it "handles multiple elements" do
    xml = '<a><b>Primo</b><b>Secondo</b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => [ "Primo", "Secondo" ] } })
    )

    xml = '<a><x><b>Primo</b><b>Secondo</b></x></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "x" => { "b" => [ "Primo", "Secondo" ] } } })
    )

    xml = '<a><b><x>Primo</x></b><b><x>Secondo</x></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" } ] } })
    )
  end

  context "rss" do
    let(:rss) { open_fixture_file('rss.xml') }
    let(:json) { JSON.parse(open_fixture_file('rss.json')) }

    it "parses the rss into json" do
      expect(XML2JSON.new(rss).parse).to eq(json)
    end
  end

  context "atom" do
    let(:atom) { open_fixture_file('atom.xml') }
    let(:json) { JSON.parse(open_fixture_file('atom.json')) }

    it "parses the atom into json" do
      expect(XML2JSON.new(atom).parse).to eq(json)
    end
  end
end
