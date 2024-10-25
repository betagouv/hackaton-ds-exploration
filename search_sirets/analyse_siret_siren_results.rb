require 'json'
require 'csv'

siret_siren_filename = "search_sirets/siret_siren.json"

file = File.read(siret_siren_filename)
data = JSON.parse(file)

results = data["results"]
results_count = data["results_count"]
total_dossiers_count = data["total_dossiers_count"]

results_per_organism = results.map{|r| r['organisme']}.tally
dossiers_per_organism = results.reduce({}) do |h, r|
  org = r['organisme']
  h[org] = 0 if h[org] == nil
  h[org] += r['dossiersCount']
  h
end

puts "Organisme	démarches	dossiers"
puts results_per_organism.map{|org,demarches| [org,demarches,dossiers_per_organism[org]]}.sort_by{|row| -row[2]}.map{|row| row.join("\t")}

# results_per_title = results.map{|r| r['title']}.tally
# dossiers_per_title = results.reduce({}) do |h, r|
#   title = r['title']
#   h[title] = 0 if h[title] == nil
#   h[title] += r['dossiersCount']
#   h
# end

# puts "Titre	démarches	dossiers"
# puts results_per_title.map{|title,demarches| [org,demarches,dossiers_per_title[title]].join("\t")}.sort_by{|row| row[2]}

