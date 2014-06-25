class Configuration
  attr_accessor :attributes_key, :namespaces_key, :text_key

  def initialize
    self.attributes_key = '_attributes'
    self.namespaces_key = '_namespaces'
    self.text_key = '_text'
  end
end
