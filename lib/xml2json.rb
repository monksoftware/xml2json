require 'nokogiri'
require 'json'

module XML2JSON
  class InvalidXML < StandardError; end

  def self.parse xml
    begin
      doc = Nokogiri.XML(xml) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError
      raise InvalidXML.new
    end

    root = doc.root
    hash = { root.name => parse_node(root) }
    hash[root.name] = { "_namespaces" => root.namespaces }.merge(hash[root.name]) unless root.namespaces.empty?
    hash.to_json
  end


  def self.parse_node(node)
    if node.element_children.count > 0
      parse_attributes(node).merge(node2json(node))
    else
      (node.attributes.empty? ? node.text : parse_attributes(node).merge({"_text" => node.text}))
    end
  end

  def self.parse_attributes(node)
    node.attributes.empty? ? {} : {"_attributes" => Hash[node.attributes.map { |k, v| [k, v.value] } ]}
  end

  def self.node2json node
    node.element_children.each_with_object({}) do |child, hash|
      key = namespaced_node_name child

      if hash.has_key?(key)
        node_to_nodes!(hash, child)
        hash[key] << parse_node(child)
      else
        hash[key] = parse_node(child)
      end

    end
  end

  def self.node_to_nodes! hash, node
    key = namespaced_node_name(node)
    if !hash[key].is_a?(Array)
      tmp = hash[key]
      hash[key] = []
      hash[key] << tmp
    end
  end

  def self.namespaced_node_name node
    "#{prefix(node)}#{node.name}"
  end

  def self.prefix node
    if !node.namespace.nil? && !node.namespace.prefix.nil? && !node.namespace.prefix.strip.empty?
      "#{node.namespace.prefix}:"
    else
      ""
    end
  end

  class Configuration
    attr_accessor :attributes_key, :namespaces_key, :text_key

    def initialize
      self.attributes_key = '_attributes'
      self.namespaces_key = '_namespaces'
      self.text_key = '_text'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.config
    yield configuration if block_given?
  end

  def self.reset
    @configuration = Configuration.new
  end
end
