require_relative './attachments_handler'

class Ngrams < AttachmentsHandler
  def initialize(words_count)
    super()
    @words_count = words_count
    @result = ngrams_counts(@words_count, useful_data)
  end

  def ngrams_counts(word_count, data)
    all_ngrams(word_count, data)
      # .tally
      # .sort_by{|ngram, count| -count}
      # .to_h
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
    ngrams(sentence.split(/[\s',.?!;]+/), count).map{|words| words.join(' ')}
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
    write_json("words_analysis/sequence_of_#{@words_count}_words.json", @result)

    puts "#{@result.flatten.count} résultats"
  end
end