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

# puts "#{p_number data.count} Démarches au total"
# data_with_dossiercount = data.select{|d| d['dossiersCount'] > 0}
# puts "#{p_number data_with_dossiercount.count} Démarches avec au moins un dossier"


def words_of(field_descriptor)
  [field_descriptor['label'], field_descriptor['description'] || nil].compact.join(' ## ')
end

useful_data = data.map do |d|
  {
    number: d['number'],
    dossiersCount: d['dossiersCount'],
    words: d['revision']['champDescriptors'].map{|cd| words_of(cd)}
  }
end

# pp useful_data.first

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
    d[:words] = d[:words].select{|words| words.downcase =~ regex }
    d
  end
end

query = ARGV[0]
search_results = search(query, useful_data)

puts "Résultats de la recherche #{query} : #{p_number search_results.count} résultats:\n\n"
search_results.each{ |r| pp r; puts "\n"}
