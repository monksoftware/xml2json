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
        hash[child.name] << (has_children ? node2json(child) : child.text)
      else
        if child.attributes.empty?
          hash[child.name] = (has_children ? node2json(child) : child.text)
        else
          hash[child.name] = {
            "_attributes" => Hash[child.attributes.map { |k, v| [k, v.value] } ],
            "_text" => (has_children ? node2json(child) : child.text)
          }
        end
      end
    end
  end
end
