require 'json'

def json_pp(h)
  puts JSON.pretty_generate(h)
end

def p_number(n)
  n.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

DATA_PATH = '../20240901041013-demarches.json'

file = File.read(DATA_PATH)
data = JSON.parse(file)

puts "#{p_number data.count} Démarches au total"
# json_pp data.first

data_with_dossiercount = data.select{|d| d['dossiersCount'] > 0}
puts "#{p_number data_with_dossiercount.count} Démarches avec au moins un dossier"
