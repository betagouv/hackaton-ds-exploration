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

# EXPLORE REVISIONS KEYS ""
# data_grouped_by_revisions_keys_count = data_with_dossiercount.inject(Hash.new(0)) { |h, e| h[e['revision'].keys.first] += 1 ; h }
# pp data_grouped_by_revisions_keys_count
# {"champDescriptors"=>19138} (OK there is always one key)

# COUNT PER AMOUNT OF FIELDS #
# data_grouped_by_champDescriptors_count = data_with_dossiercount.inject(Hash.new(0)) { |h, e| h[e['revision']['champDescriptors'].count] += 1 ; h }.sort.to_h
# puts "Nombre de champs => nombre de dossiers"
# pp data_grouped_by_champDescriptors_count
# There is between 1 and ~120 fields

# COUNT PER DOSSIER #
data_per_dossiercount = data.inject(Hash.new(0)) { |h, e| h[e['dossiersCount']] += 1 ; h }.sort.to_h
# pp data_per_dossiercount
puts "La démarche qui a le plus de dossiers en a : #{p_number data_per_dossiercount.keys.max}"

# DEMARCHES GROUPED BY DOSSIERS AMOUNT ^ 10 #

data_per_rounded_dossiers_count = data_with_dossiercount.inject({}) do |h, e|
  rounded_amount = 10 ** (e['dossiersCount'].to_s.length)
  h[rounded_amount] = [] unless h[rounded_amount]
  h[rounded_amount].push e['number']
  h
end.sort.to_h
# pp data_per_rounded_dossiers_count

data_per_rounded_dossiers_count.each do |count, dossiers|
  puts "Démarches avec entre #{count/10} et #{count} dossiers : #{dossiers.count}"
end