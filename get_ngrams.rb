require_relative './app/ngrams'

t1 = Time.now

ngrams = Ngrams.new

(1..4).each do |i|
  ngrams.compute(i).print_result
end

t2 = Time.now
seconds = (t2 - t1)
minutes = seconds / 60
leftover_seconds = seconds % 60
puts "Durée du traitement : #{minutes}min #{leftover_seconds}s"