# xml2json

[![Code Climate](https://codeclimate.com/github/monksoftware/xml2json.png)](https://codeclimate.com/github/monksoftware/xml2json) [![Gem Version](https://badge.fury.io/rb/xml2json.svg)](http://badge.fury.io/rb/xml2json)

Transforms XML into JSON

## Installation

Add this to your Gemfile

```ruby
gem 'xml2json', git: 'git@github.com:monksoftware/xml2json.git'
```

## Configuration

Attributes, text and namespaces key name can be customized, defaults are `_attributes`, `_text` and `_namespaces`

```ruby
XML2JSON.config do |c|
	c.attributes_key = "attr"
	c.namespaces_key = "nsp"
	c.text_key = "txt"
end
```

## Usage

```ruby
XML2JSON.parse(xml_string)         # => this outputs a json string
XML2JSON.parse_to_hash(xml_string) # => this outputs a ruby hash
```

## Examples

### Input XML

```ruby
xml = '<?xml version="1.0" encoding="utf-8"?>
		<root>
	   		<author><name>Andrea</name><email>andrea@wearemonk.com</email></author>
	   		<author><name>Giuseppe</name><email>giuseppe@wearemonk.com</email></author>
	   	</root>'
```

### Parse to JSON string

```
XML2JSON.parse(xml)
```

output is a string

```json
{"root":{"authors":[{"name":"Andrea", "email":"andrea@wearemonk.com"},{"name":"Giuseppe", "email":"giuseppe@wearemonk.com"}]}}
```

### Parse to Ruby Hash

```
XML2JSON.parse_to_hash(xml)
```

output is a hash

```ruby
{"root" => {"authors" => [{"name" => "Andrea", "email" => "andrea@wearemonk.com"},{"name" => "Giuseppe", "email" => "giuseppe@wearemonk.com"}]}}
```
