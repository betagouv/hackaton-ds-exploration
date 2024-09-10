require 'json'
require_relative './json_handler'

class SearchAttachments < JsonHandler
  USEFUL_FIELDS_TYPES = %w[RepetitionChampDescriptor PieceJustificativeChampDescriptor]

  def initialize(query)
    super()
    @query = query

    search_results = search(@query, data_with_attachments)
    @result = {
      query: @query,
      results_count: search_results.count,
      total_dossiers_count: search_results.map{|r| r[:dossiersCount]}.sum,
      results: search_results.sort_by{|r| -r[:dossiersCount]}
    }
  end

  def all_words_of(field_descriptor)
    first_level_words = words_of(field_descriptor)
    second_level_words = field_descriptor['champDescriptors'].map{|d| all_words_of(d)} if field_descriptor['champDescriptors']

    [first_level_words, second_level_words].flatten.compact.join(' ## ')
  end

  def words_of(field_descriptor)
    description = field_descriptor['description'] == "" ? nil : field_descriptor['description']
    [field_descriptor['label'], description]
  end

  def data_with_attachments
    @data.map do |d|
      orga = d['service'] ? d['service']['organisme'] : nil
      {
        id: d['number'],
        dossiersCount: d['dossiersCount'],
        title: d['title'],
        organisme: orga,
        link: "https://github.com/betagouv/hackaton-ds-exploration/blob/main/demarches/#{d['number']}.json",
        words: d['revision']['champDescriptors'].select do |cd|
          USEFUL_FIELDS_TYPES.include? cd['__typename'] || cd['champDescriptors']
        end.map{|cd| all_words_of(cd)}
      }
    end
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

  def sanitize_filename(filename)
    filename = filename.gsub('\s', ' ')
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
    return fn.join '.'
  end

  def print_result
    result_filename = sanitize_filename("#{@query}.json")
    
    write_json("search_attachments/#{result_filename}", @result)

    "#{@result.count} résultats"
  end
end