module SpecHelpers
  def self.open_fixture_file(name)
    File.read(File.join(Dir.pwd, 'spec', 'fixtures', name))
  end
end
