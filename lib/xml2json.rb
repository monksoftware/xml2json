require 'nokogiri'

module XML2JSON
  def self.parse xml
    root = Nokogiri.XML(xml).root
    { root.name => node2json(root) }
  end

  def self.node2json node
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
end
