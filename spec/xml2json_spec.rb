require 'rspec/autorun'
require 'spec_helper'
require 'xml2json'
require 'json'

describe XML2JSON do
  it "parses xml into json" do
    xml = '<a><b><c>Hello</c><d>World</d></b></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "b" => { "c" => "Hello", "d" => "World" } } })
    )

    xml = '<a><b><x>Io</x><c><d>Hello</d><e>World</e></c></b></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "b" => { "x" => "Io", "c" => { "d" => "Hello", "e" => "World" } } } })
    )
  end

  it "handles multiple elements" do
    xml = '<a><x><b>Primo</b><b>Secondo</b></x></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "x" => { "b" => [ "Primo", "Secondo" ] } } })
    )

    xml = '<a><b><x>Primo</x></b><b><x>Secondo</x></b></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" } ] } })
    )
  end

  it "parses node attributes" do
    xml = '<r><a url="www.google.it"></a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"a" => { "_attributes" => {"url" => "www.google.it"}, "_text" => ""}}})
    )
  end

  context "rss" do
    let(:rss) { SpecHelpers.open_fixture_file('rss.xml') }
    let(:json) { JSON.parse(SpecHelpers.open_fixture_file('rss.json')) }

    xit "parses the rss into json" do
      expect(XML2JSON.parse(rss)).to eq(json)
    end
  end

  context "atom" do
    let(:atom) { SpecHelpers.open_fixture_file('atom.xml') }
    let(:json) { JSON.parse(SpecHelpers.open_fixture_file('atom.json')) }

    xit "parses the atom into json" do
      expect(XML2JSON.parse(atom)).to eq(json)
    end
  end
end
