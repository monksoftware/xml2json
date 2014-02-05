require 'nokogiri'

module XML2JSON
  def self.parse xml
    root = Nokogiri.XML(xml).root
    { root.name => node2json(root) }
  end

  def self.node2json node
    node.element_children.each_with_object({}) do |child, hash|
      
      has_children = child.element_children.count > 0

      if hash.has_key?(child.name)
        tmp = hash[child.name]
        hash[child.name] = []
        hash[child.name] << tmp
        hash[child.name] << parse_node(child)
      else
        hash[child.name] = parse_node(child)
      end

    end
  end

  def self.parse_node(node)
    if node.element_children.count > 0
      parse_attributes(node).merge(node2json(node))
    else
      (node.attributes.empty? ? node.text : parse_attributes(node).merge({"_text" => node.text}))
    end
  end

  def self.parse_attributes(node)
    if node.attributes.empty?
      {}
    else
      {"_attributes" => Hash[node.attributes.map { |k, v| [k, v.value] } ]}
    end
  end
  
end