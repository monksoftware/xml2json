# xml2json

Transforms XML into JSON

## Installation

Add this to your Gemfile

`gem 'xml2json', git: 'git@github.com:monksoftware/xml2json.git'`

## Usage

`XML2JSON.parse(xml_string)`

## Examples
	
		xml = '<?xml version="1.0" encoding="utf-8"?>
				<root>
			   		<author><name>Andrea</name><email>andrea@wearemonk.com</email></author>
			   		<author><name>Giuseppe</name><email>giuseppe@wearemonk.com</email></author>
			   	</root>'

		XML2JSON.parse(xml)

output

		{"root":{"author":[{"name":"Andrea", "email":"andrea@wearemonk.com"},{"name":"Giuseppe", "email":"giuseppe@wearemonk.com"}]}}
