require 'nokogiri'
require 'json'
require 'active_support/inflector'
require_relative './xml2json/configuration'

module XML2JSON
  class InvalidXML < StandardError; end

  def self.parse xml
    parse_to_hash(xml).to_json
  end

  def self.parse_to_hash xml
    begin
      doc = Nokogiri.XML(xml) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError
      raise InvalidXML.new
    end

    root = doc.root
    hash = { root.name => parse_node(root) }
    hash[root.name] = { self.configuration.namespaces_key => root.namespaces }.merge(hash[root.name]) unless root.namespaces.empty?
    hash
  end


  def self.parse_node(node)
    if node.element_children.count > 0
      parse_attributes(node).merge(node2json(node))
    else
      (node.attributes.empty? ? node.text : parse_attributes(node).merge(text_hash(node)))
    end
  end

  def self.text_hash(node)
    return {} if node.text.strip.empty?
    { self.configuration.text_key => node.text }
  end

  def self.parse_attributes(node)
    node.attributes.empty? ? {} : { self.configuration.attributes_key => Hash[node.attributes.map { |k, v| [k, v.value] } ]}
  end

  def self.node2json node
    node.element_children.each_with_object({}) do |child, hash|
      key = namespaced_node_name child
      pluralized_key = key.pluralize

      if hash.has_key?(key)
        node_to_nodes!(hash, child)
        hash.delete(key)
        hash[pluralized_key] << parse_node(child)
      else
        if hash.has_key?(pluralized_key)
          hash[pluralized_key] << parse_node(child)
        else
          hash[key] = parse_node(child)
        end
      end

    end
  end

  def self.node_to_nodes! hash, node
    key = namespaced_node_name(node)
    if !hash[key].is_a?(Array)
      tmp = hash[key]
      hash[key.pluralize] = []
      hash[key.pluralize] << tmp
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
