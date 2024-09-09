require 'json'

DATA_PATH = '../20240901041013-demarches.json'

file = File.read(DATA_PATH)
data = JSON.parse(file)

def words_of(field_descriptor)
  [field_descriptor['label'], field_descriptor['description'] || nil].compact.join(' ## ')
end

useful_data = data.map do |d|
  {
    id: d['number'],
    dossiersCount: d['dossiersCount'],
    link: "https://github.com/betagouv/hackaton-ds-exploration/blob/main/demarches/#{d['number']}.json",
    words: d['revision']['champDescriptors'].select{|cd| cd['__typename'] == 'PieceJustificativeChampDescriptor'}.map{|cd| words_of(cd)}
  }
end

def search(regex, data)
  regex = /#{regex}/ if regex.is_a? String

  matched_data = data.select do |d|
    matched = false
    
    d[:words].each do |words| 
      if words.downcase =~ regex 
        matched = true
        break
      end
    end

    matched
  end.map do |d|
    d[:matchs] = d[:words].select{|words| words.downcase =~ regex }
    d.delete :words
    d
  end
end

query = ARGV[0]
search_results = search(query, useful_data)
result = {
  query: query,
  results_count: search_results.count,
  total_dossiers_count: search_results.map{|r| r[:dossiersCount]}.sum,
  results: search_results.sort_by{|r| -r[:dossiersCount]}
}

def sanitize_filename(filename)
  filename = filename.gsub('\s', ' ')
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
  return fn.join '.'
end

result_filename = sanitize_filename("#{query}.json")
File.open("search_attachments/#{result_filename}", 'w') do |f|
  f.write(JSON.pretty_generate(result))
end