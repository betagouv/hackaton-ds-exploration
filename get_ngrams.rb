require_relative './app/ngrams'

ngrams = Ngrams.new

(1..4).each do |i|
  ngrams.compute(i).print_result
end
