require 'json'

class DataSource
  DATA_PATH = '../20240901041013-demarches.json'

  attr_accessor :data

  def initialize
    file = File.read(DATA_PATH)
    @data = JSON.parse(file)    
  end
end
