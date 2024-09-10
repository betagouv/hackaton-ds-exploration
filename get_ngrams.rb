require_relative './app/ngrams'

t1 = Time.now

ngrams = Ngrams.new

(1..4).each do |i|
  ngrams.compute(i).print_result
end

t2 = Time.now
duration = (t2 - t1)
puts "Durée du traitement : #{duration}s"