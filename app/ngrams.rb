require_relative './attachments_handler'

class Ngrams < AttachmentsHandler
  def initialize(words_count)
    super()
    @words_count = words_count
    @result = all_ngrams(@words_count, useful_data[0..10])
  end

  def all_ngrams(words_count, data)
    data.map do |d|
      d[:words].map do |words|
        ngrams = ngrams_of_words(words, words_count)
      end.compact.inject(:+)
    end.compact.inject(:+)
  end

  def all_words
    @all_words ||= useful_data.map do |d|
      d[:words].map{|words| words.split("\s")}
    end
  end

  def print_result
    write_json("words_analysis/sequence_of_#{@words_count}_words.json", @result)

    puts "#{all_words.flatten.count} résultats"
  end

  def ngrams_of_words(sentence, count)
    ngrams(sentence.split("\s"), count).map{|words| words.join(' ')}
  end

  def ngrams(array, count)
    ngrams = []
    range = 0..(array.length - count)

    range.each do |index|
      ngrams.push array[index..(index+count - 1)]
    end
    
    ngrams
  end
end