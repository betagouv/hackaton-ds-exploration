require 'json'

SEARCH_FOLDER = 'search_attachments'
RESULT_FILE = 'search_summary.json'
all_searches = []

Dir.foreach(SEARCH_FOLDER) do |filename|
  next if filename == '.' or filename == '..'
  full_filename = "#{SEARCH_FOLDER}/#{filename}"
  file = File.read(full_filename)
  data = JSON.parse(file)
  all_searches.push data.merge({link: "https://github.com/betagouv/hackaton-ds-exploration/blob/main/#{full_filename}"})
end

summary = all_searches
  .sort_by{ |d| -d['total_dossiers_count'] }
  .map{ |d| d.except 'results' }
  
File.open(RESULT_FILE, 'w') do |f|
  f.write(JSON.pretty_generate(summary))
end