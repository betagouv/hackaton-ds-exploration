class QueryManager
  STOP_WORDS_PATH = 'app/french_stop_words.yml'
  SPLIT_REGEX = /[\s’<>'",.?!;:\-\d()+*°•\/\\]+/

  def initialize(queries)
   @queries = queries
  end

  def regexize
    @queries.map do |query|
      destopped_query = remove_stop_words(query)

    end.join(".{1,10}?")
  end

  def remove_stop_words(query)
    words = query.downcase.split(SPLIT_REGEX)
    relevant_words = (words - stop_words) - [""]
    relevant_words.join('')
  end

  def regexize_small_words(query)
    return query if query.length > 10
    
  end

  def stop_words
    @stop_words ||= YAML.load_file(STOP_WORDS_PATH)
  end
end