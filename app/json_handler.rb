require 'json'

class JsonHandler
  DATA_PATH = '../20240901041013-demarches.json'

  def initialize
    file = File.read(DATA_PATH)
    @data = JSON.parse(file)    
  end

  def write_json(filename, content)
    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate(content))
    end
  end
end
