require_relative './attachments_handler'

class Ngrams < AttachmentsHandler
  def initialize(words_count)
    super()
    @words_count = words_count
    @result = get_ngrams(@words_count, useful_data)
  end

  def get_ngrams(words_count, data)
    "coucou"
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
end