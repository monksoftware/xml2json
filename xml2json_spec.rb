require 'rspec/autorun'
require_relative 'xml2json'

describe XML2JSON do
  it "parses xml into json" do
    xml = '<a><b>Hello</b></a>'
    expect(XML2JSON.new(xml).parse).to eq({ "a" => { "b" => "Hello" } })

    xml = '<a><b>Hello</b><c>World</c></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => "Hello", "c" => "World" } })
    )

    xml = '<a><b><c>World</c></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "c" => "World" } } })
    )

    xml = '<a><b><c>Hello</c><d>World</d></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "c" => "Hello", "d" => "World" } } })
    )

    xml = '<a><b><c><d>World</d></c></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "c" => { "d" => "World" } } } })
    )

    xml = '<a><b><c><d>Hello</d><e>World</e></c></b></a>'
    expect(XML2JSON.new(xml).parse).to(
      eq({ "a" => { "b" => { "c" => { "d" => "Hello", "e" => "World" } } } })
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
    let(:rss) {
      <<-END_RSS
      <rss version="2.0">
        <channel>
          <title>Primo RSS</title>
          <link>http://primorss.com</link>
          <description>RSS Valido</description>

          <item>
            <title>Entry Title</title>
            <description>Description</description>
            <link>url</link>
          </item>

          <item>
            <title>Entry Title 2</title>
            <description>Description</description>
            <link>url</link>
          </item>
        </channel>
      </rss>'
      END_RSS
    }

    let(:json) {
      {
        "rss" => {
          "channel" => {
            "title" => "Primo RSS",
            "link" => "http://primorss.com",
            "description" => "RSS Valido",
            "item" => [
              {
                "title" => "Entry Title",
                "description" => "Description",
                "link" => "url"
              }, {
                "title" => "Entry Title 2",
                "description" => "Description",
                "link" => "url"
              }
            ]
          }
        }
      }
    }

    it "parses the rss into json" do
      expect(XML2JSON.new(rss).parse).to eq(json)
    end
  end
end
