require 'nokogiri'

module XML2JSON
  def self.parse xml
    root = Nokogiri.XML(xml).root
    { root.name => parse_node(root) }
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

      if hash.has_key?(child.name)
        node_to_nodes!(hash, child)
        hash[child.name] << parse_node(child)
      else
        hash[child.name] = parse_node(child)
      end

    end
  end

  def self.node_to_nodes! hash, node
    if !hash[node.name].is_a?(Array)
      tmp = hash[node.name]
      hash[node.name] = []
      hash[node.name] << tmp
    end
  end
end
