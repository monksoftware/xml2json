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
        if child.attributes.empty?
          hash[child.name] << (has_children ? node2json(child) : child.text)
        else
          if has_children
            hash[child.name] << parse_attributes(child).merge(node2json(child))
          else
            hash[child.name] << parse_attributes(child).merge({"_text" => child.text})
          end
        end
      else
        if child.attributes.empty?
          hash[child.name] = (has_children ? node2json(child) : child.text)
        else
          if has_children
            hash[child.name] = parse_attributes(child).merge(node2json(child))
          else
            hash[child.name] = parse_attributes(child).merge({"_text" => child.text})
          end
        end
      end
    end
  end

  def self.parse_attributes(node)
    {"_attributes" => Hash[node.attributes.map { |k, v| [k, v.value] } ]}
  end
end
