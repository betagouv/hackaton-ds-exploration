require 'json'
require 'csv'


def make_csv(rows, filename)
  csv_string = CSV.generate do |csv|
    rows.each do |row|
      csv << row
    end
  end
  File.write(filename, csv_string)
end


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

make_csv(
  [%w[Organisme	démarches	dossiers]] + results_per_organism.map{|org,demarches| [org,demarches,dossiers_per_organism[org]]}.sort_by{|row| -row[2]},
  "search_sirets/results_per_organism.csv"
)

results_per_title = results.map{|r| r['title']}.tally
dossiers_per_title = results.reduce({}) do |h, r|
  title = r['title']
  h[title] = 0 if h[title] == nil
  h[title] += r['dossiersCount']
  h
end

make_csv(
  [%w[Titre	démarches	dossiers]] + results_per_title.map{|title,demarches| [title,demarches,dossiers_per_title[title]]}.sort_by{|row| -row[2]},
  "search_sirets/results_per_title.csv"
)

