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
# json_pp data_with_dossiercount.first

# data_grouped_by_revisions_keys_count = data_with_dossiercount.inject(Hash.new(0)) { |h, e| h[e['revision'].keys.first] += 1 ; h }
# pp data_grouped_by_revisions_keys_count
# {"champDescriptors"=>19138} (OK there is always one key)

data_grouped_by_champDescriptors_count = data_with_dossiercount.inject(Hash.new(0)) { |h, e| h[e['revision']['champDescriptors'].count] += 1 ; h }.sort.to_h
puts "Nombre de champs => nombre de dossiers"
pp data_grouped_by_champDescriptors_count
# There is between 1 and ~120 fields
