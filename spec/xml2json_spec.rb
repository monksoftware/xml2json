require 'rspec/autorun'
require 'spec_helper'
require 'xml2json'

describe XML2JSON do
  it "parses xml into json" do
    xml = '<a><b><c>Hello</c><d>World</d></b></a>'
    json = { "a" => { "b" => { "c" => "Hello", "d" => "World" } } }.to_json
    expect(XML2JSON.parse(xml)).to eq(json)

    xml = '<a><b><x>Io</x><c><d>Hello</d><e>World</e></c></b></a>'
    json = { "a" => { "b" => { "x" => "Io", "c" => { "d" => "Hello", "e" => "World" } } } }.to_json
    expect(XML2JSON.parse(xml)).to eq(json)
  end

  it "handles multiple elements" do
    xml = '<a><x><b>Primo</b><b>Secondo</b></x></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "x" => { "b" => [ "Primo", "Secondo" ] } } }.to_json)
    )

    xml = '<a><b><x>Primo</x></b><b><x>Secondo</x></b></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" } ] } }.to_json)
    )

    xml = '<a><b><x>Primo</x></b><b><x>Secondo</x></b><b><x>Terzo</x></b></a>'
    expect(XML2JSON.parse(xml)).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" }, { "x" => "Terzo" }] } }.to_json)
    )
  end

  it "parses node attributes" do
    xml = '<r><a url="www.google.it"></a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"a" => { "_attributes" => {"url" => "www.google.it"}, "_text" => ""}}}.to_json)
    )

    xml = '<r><a url="www.google.it"><b>ciao</b></a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"a" => { "_attributes" => {"url" => "www.google.it"}, "b" => "ciao"}}}.to_json)
    )

    xml = '<r><a url="www.google.it"></a><a url="www.google.com"></a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"a" => [{ "_attributes" => {"url" => "www.google.it"}, "_text" => ""},{ "_attributes" => {"url" => "www.google.com"}, "_text" => ""}]}}.to_json)
    )

    xml = '<r><a url="www.google.it"><b>ciao</b></a><a url="www.google.com"><b>ciao</b></a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"a" => [{ "_attributes" => {"url" => "www.google.it"}, "b" => "ciao"},{ "_attributes" => {"url" => "www.google.com"}, "b" => "ciao"}]}}.to_json)
    )
  end

  it "parses root attributes" do
    xml = '<r id="1"><a>Hello</a></r>'
    expect(XML2JSON.parse(xml)).to(
      eq({"r" => {"_attributes" => { "id" => "1" }, "a" => "Hello" } }.to_json)
    )
  end

  context "namespaces" do
    let(:xml) { '<r xmlns:content="http://purl.org/rss/1.0/modules/content/"><content:encoded>Hello</content:encoded><content:encoded>World</content:encoded></r>' }
    it "parses namespaced node names" do
      expect(XML2JSON.parse(xml)).to(
        eq({"r" => { "_namespaces" => { "xmlns:content" => "http://purl.org/rss/1.0/modules/content/" }, "content:encoded" => [ "Hello", "World" ] } }.to_json)
      )
    end
  end

  context "rss" do
    let(:rss) { SpecHelpers.open_fixture_file('rss.xml') }
    let(:json) { SpecHelpers.open_fixture_file('rss.json').delete("\n") }

    it "parses the rss into json" do
      expect(XML2JSON.parse(rss)).to eq(json)
    end
  end

  context "atom" do
    let(:atom) { SpecHelpers.open_fixture_file('atom.xml') }
    let(:json) { SpecHelpers.open_fixture_file('atom.json').delete("\n") }

    it "parses the atom into json" do
      expect(XML2JSON.parse(atom)).to eq(json)
    end
  end

  context "invalid xml file" do
    it "raises an exception if the xml file is bad formed" do
      xml = '<invalid></xml>'
      expect {
        XML2JSON.parse(xml)
      }.to raise_error XML2JSON::InvalidXML

      xml = 'not xml file'
      expect {
        XML2JSON.parse(xml)
      }.to raise_error XML2JSON::InvalidXML
    end
  end

  context "configuration" do
    it "let's the user choose the keys" do
      XML2JSON.config do |c|
        c.attributes_key = 'attr'
        c.namespaces_key = 'names'
        c.text_key = 'body'
      end
      expect(XML2JSON.configuration.attributes_key).to eq('attr')
      expect(XML2JSON.configuration.namespaces_key).to eq('names')
      expect(XML2JSON.configuration.text_key).to eq('body')
    end
  end
end
