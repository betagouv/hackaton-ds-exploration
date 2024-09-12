require 'yaml'
require_relative './fields_handler'
require_relative './attachments_filter'

class Ngrams < FieldsHandler
  include AttachmentsFilter

  STOP_WORDS_PATH = 'app/french_stop_words.yml'
  MIN_RELEVANT_COUNT = 10
  SPLIT_REGEX = /[\s’<>'",.?!;:\-\d()+*°•\/\\]+/

  def compute(words_count)
    @words_count = words_count

    puts "Counting #{words_count}-grams in data..."
    @result = ngrams_counts(@words_count, useful_data)
    puts "#{@result.flatten.count} #{words_count}-grams trouvés"

    puts "Counting weighted #{words_count}-grams in data..."
    @weighted_result = weighted_ngrams_counts(@words_count, useful_data)
    puts "#{@weighted_result.flatten.count} weighted #{words_count}-grams trouvés"

    self
  end

  def ngrams_counts(word_count, data)
    select_and_sort_ngrams(
      all_ngrams(word_count, data).tally
    )
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

  def weighted_ngrams_counts(words_count, data)
    weighted_ngrams_counts = {}
    
    data.each do |d|
      ngrams_of_data = []

      d[:words].map do |words|
        ngrams_of_data.concat ngrams_of_words(words, words_count)
      end

      ngrams_of_data.uniq.each do |ngram|
        weighted_ngrams_counts[ngram] = 0 unless weighted_ngrams_counts[ngram]
        weighted_ngrams_counts[ngram] += d[:dossiersCount]
      end
    end

    select_and_sort_ngrams(weighted_ngrams_counts)
  end

  def select_and_sort_ngrams(ngrams_hash)
    ngrams_hash
      .select{|ngram, count| count >= 10}
      .sort_by{|ngram, count| -count}
      .to_h
  end

  def ngrams_of_words(sentence, count)
    words = sentence.downcase.split(SPLIT_REGEX)
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
    write_json("words_analysis/sequences_of_#{@words_count}_words - weighted.json", @weighted_result)
  end

  def stop_words
    @stop_words ||= YAML.load_file(STOP_WORDS_PATH)
  end
end