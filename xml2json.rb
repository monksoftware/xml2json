require 'rspec/autorun'
require 'nokogiri'

describe "xml2json" do
  it "parses xml into json" do
    expect(xml2json('<a><b>Hello</b></a>')).to eq({ "a" => { "b" => "Hello" } })
    expect(xml2json('<a><b>Hello</b><c>World</c></a>')).to(
      eq({ "a" => { "b" => "Hello", "c" => "World" } })
    )

    expect(xml2json('<a><b><c>World</c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => "World" } } })
    )

    expect(xml2json('<a><b><c>Hello</c><d>World</d></b></a>')).to(
      eq({ "a" => { "b" => { "c" => "Hello", "d" => "World" } } })
    )

    expect(xml2json('<a><b><c><d>World</d></c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => { "d" => "World" } } } })
    )

    expect(xml2json('<a><b><c><d>Hello</d><e>World</e></c></b></a>')).to(
      eq({ "a" => { "b" => { "c" => { "d" => "Hello", "e" => "World" } } } })
    )

    expect(xml2json('<a><b><x>Io</x><c><d>Hello</d><e>World</e></c></b></a>')).to(
      eq({ "a" => { "b" => { "x" => "Io", "c" => { "d" => "Hello", "e" => "World" } } } })
    )
  end

  it "handles multiple elements" do
    expect(xml2json('<a><b>Primo</b><b>Secondo</b></a>')).to(
      eq({ "a" => { "b" => [ "Primo", "Secondo" ] } })
    )

    expect(xml2json('<a><x><b>Primo</b><b>Secondo</b></x></a>')).to(
      eq({ "a" => { "x" => { "b" => [ "Primo", "Secondo" ] } } })
    )

    expect(xml2json('<a><b><x>Primo</x></b><b><x>Secondo</x></b></a>')).to(
      eq({ "a" => { "b" => [ { "x" => "Primo" }, { "x" => "Secondo" } ] } })
    )
  end
end

def xml2json xml
  doc = Nokogiri.XML(xml)
  node = doc.root

  { node.name => node2json(node) }
end

def node2json node
  node.element_children.each_with_object({}) do |child, hash|
    if child.element_children.count > 0
      if hash.has_key?(child.name)
        tmp = hash[child.name]
        hash[child.name] = []
        hash[child.name] << tmp
        hash[child.name] << node2json(child)
      else
        hash[child.name] = node2json(child)
      end
    else
      if hash.has_key?(child.name)
        tmp = hash[child.name]
        hash[child.name] = []
        hash[child.name] << tmp
        hash[child.name] << child.text
      else
        hash[child.name] = child.text
      end
    end
  end
end
