# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xml2json/version'

Gem::Specification.new do |spec|
  spec.name          = "xml2json"
  spec.version       = XML2JSON::VERSION
  spec.authors       = ["Giuseppe Modarelli", "Andrea D'Ippolito"]
  spec.email         = ["giuseppe.modarelli@gmail.com","adedip@gmail.com"]
  spec.summary       = %q{Transforms XML into JSON}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/monksoftware/xml2json"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_dependency "nokogiri"
end