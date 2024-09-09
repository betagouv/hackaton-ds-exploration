require 'json'

DATA_PATH = '../20240901041013-demarches.json'

file = File.read(DATA_PATH)
data = JSON.parse(file)

def json_pp(h)
  puts JSON.pretty_generate(h)
end

json_pp data.first
