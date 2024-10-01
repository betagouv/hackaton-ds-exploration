require 'json'
require 'csv'

attachments_filenames = [
  "search_attachments/_relev_e_attestation_justificatif_identit_e_compte_coordon_bancaire.json",
  "search_attachments/_rib_iban_.json",
  "search_attachments/_rib_.json",
  "search_attachments/_rib_format.json"
]

fields_filenames = [
  "search_non_attachments/_bic_.json",
  "search_non_attachments/_iban_.json",
  "search_non_attachments/_titulaire_du_compte.json",
]

attachments_stuff = {}
attachments_filenames.each do |filename|
  file = File.read(filename)
  data = JSON.parse(file)["results"]
  data.each do |demarche|
    attachments_stuff[demarche["id"]] = demarche["dossiersCount"]
  end
end

puts "Nombre de pièces jointes RIB : #{attachments_stuff.values.sum}"

fields_stuff = {}
fields_filenames.each do |filename|
  file = File.read(filename)
  data = JSON.parse(file)["results"]
  data.each do |demarche|
    fields_stuff[demarche["id"]] = demarche["dossiersCount"]
  end
end

puts "Nombre de saisies de RIB : #{fields_stuff.values.sum}"


cross_data = attachments_stuff || fields_stuff

puts "Mauvais élèves !\nNombre de démarches qui demandent le RIB en pièce jointe ET de saisir les infos : #{cross_data.count}\nNombre de dossiers #{cross_data.values.sum}"

puts cross_data.keys.join(",")