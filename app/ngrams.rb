require 'yaml'
require_relative './attachments_handler'

class Ngrams < AttachmentsHandler
  STOP_WORDS_PATH = 'app/french_stop_words.yml'
  MIN_RELEVANT_COUNT = 10

  def compute(words_count)
    @words_count = words_count

    puts "Counting #{words_count}-grams in data..."
    @result = ngrams_counts(@words_count, useful_data)
    puts "#{@result.flatten.count} ngrams trouvés"
    self
  end

  def ngrams_counts(word_count, data)
    all_ngrams(word_count, data)
      .tally
      .select{|ngram, count| count >= 10}
      .sort_by{|ngram, count| -count}
      .to_h
  end

  def all_ngrams(words_count, data)
    ngrams = []
    data.each do |d|
      d[:words].map do |words|
        ngrams.concat ngrams_of_words(words, words_count)
      end
    end
    ngrams
  end

  def ngrams_of_words(sentence, count)
    words = sentence.downcase.split(/[\s’<>'",.?!;:\-\d()+*°•\/\\]+/)
    relevant_words = (words - stop_words) - [""]
    ngrams(relevant_words, count).map{|words| words.join(' ')}
  end

  def ngrams(array, count)
    ngrams = []
    range = 0..(array.length - count)

    range.each do |index|
      ngrams.push array[index..(index+count - 1)]
    end
    
    ngrams
  end

  def print_result
    write_json("words_analysis/sequences_of_#{@words_count}_words.json", @result)
  end

  def stop_words
    @stop_words ||= YAML.load_file(STOP_WORDS_PATH)
  end
end