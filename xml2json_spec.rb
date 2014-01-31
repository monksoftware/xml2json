require 'rspec/autorun'
require_relative 'xml2json'

describe XML2JSON do
  it "parses xml into json" do
    expect(XML2JSON.parse('<a><b>Hello</b></a>')).to eq({ "a" => { "b" => "Hello" } })
    expect(XML2JSON.parse('<a><b>Hello</b><c>World</c></a>')).to(
      eq({ "a" => { "b" => "Hello", "c" => "World" } })
    )

    expect(XML2JSON.parse('<a><b><c>World</c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => "World" } } })
    )

    expect(XML2JSON.parse('<a><b><c>Hello</c><d>World</d></b></a>')).to(
      eq({ "a" => { "b" => { "c" => "Hello", "d" => "World" } } })
    )

    expect(XML2JSON.parse('<a><b><c><d>World</d></c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => { "d" => "World" } } } })
    )

    expect(XML2JSON.parse('<a><b><c><d>Hello</d><e>World</e></c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => { "d" => "Hello", "e" => "World" } } } })
    )

    expect(XML2JSON.parse('<a><b><x>Io</x><c><d>Hello</d><e>World</e></c></b></a>')).to(
      eq({ "a" => { "b" => { "x" => "Io", "c" => { "d" => "Hello", "e" => "World" } } } })
    )
  end

  it "handles multiple elements" do
    expect(XML2JSON.parse('<a><b>Primo</b><b>Secondo</b></a>')).to(
      eq({ "a" => { "b" => [ "Primo", "Secondo" ] } })
    )

    expect(XML2JSON.parse('<a><x><b>Primo</b><b>Secondo</b></x></a>')).to(
      eq({ "a" => { "x" => { "b" => [ "Primo", "Secondo" ] } } })
    )

    expect(XML2JSON.parse('<a><b><x>Primo</x></b><b><x>Secondo</x></b></a>')).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" } ] } })
    )
  end
end
