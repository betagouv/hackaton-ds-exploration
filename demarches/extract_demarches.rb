require 'json'

DATA_PATH = '../../20240901041013-demarches.json'

file = File.read(DATA_PATH)
data = JSON.parse(file)

data.each do |d|
  filename = "#{d['number']}.json"
  File.open(filename, 'w') do |f|
    f.write(JSON.pretty_generate(d))
  end
end