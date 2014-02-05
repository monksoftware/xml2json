require 'nokogiri'

module XML2JSON
  def self.parse xml
    root = Nokogiri.XML(xml).root
    json = { root.name => parse_node(root) }
    json[root.name].merge!({ "_namespaces" => root.namespaces }) unless root.namespaces.empty?
    json
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
end
