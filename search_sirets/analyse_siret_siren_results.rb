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



# puts "#{results_count} démarches demandant un siret"
# puts "#{total_dossiers_count} dossiers au total"
puts "Organisme	démarches	dossiers"
puts results_per_organism.map{|org,demarches| [org,demarches,dossiers_per_organism[org]].join("\t")}.sort_by{|row| row[2]}
