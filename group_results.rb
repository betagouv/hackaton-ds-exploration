require 'json'
require 'csv'

filename = ARGV[0]
file = File.read(filename)
data = JSON.parse(file)

grouped_results = data["results"].reduce({}) do |h, result|
  orga = result["organisme"]
  h[orga] = {demarches: 0, dossiers: 0} unless h[orga]
  
  h[orga][:demarches] += 1
  h[orga][:dossiers] += result["dossiersCount"]
  h
end.sort_by do |key, value|
  -value[:dossiers]
end.to_h

# puts grouped_results

csv_string = CSV.generate(col_sep: "\t") do |csv|
  csv << ["orga", *grouped_results.values.first.keys]

  grouped_results.each do |orga, result|
    csv << [orga, *result.values]
  end
end

puts csv_string