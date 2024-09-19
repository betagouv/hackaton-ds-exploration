require 'json'
require 'csv'

class SearchSummary
  SEARCH_FOLDER = 'search_attachments'
  RESULT_JSON_FILE = 'search_summary.json'
  RESULT_CSV_FILE = 'search_summary.csv'

  def summarize
    all_searches = []

    Dir.foreach(SEARCH_FOLDER) do |filename|
      next if filename == '.' or filename == '..'
      full_filename = "#{SEARCH_FOLDER}/#{filename}"
      file = File.read(full_filename)
      data = JSON.parse(file)
      all_searches.push data.merge({link: "https://github.com/betagouv/hackaton-ds-exploration/blob/main/#{full_filename}"})
    end

    summary = all_searches
      .sort_by{ |d| -d['total_dossiers_count'] }
      .map{ |d| d.except 'results' }
      
    File.open(RESULT_JSON_FILE, 'w') do |f|
      f.write(JSON.pretty_generate(summary))
    end

    File.write(RESULT_CSV_FILE, csv_summary(summary))

    puts "Summary updated."
  end

  def csv_summary(summary)
    column_names = summary.first.keys
    csv_string = CSV.generate do |csv|
      csv << column_names
      summary.each do |search_summary|
        csv << search_summary.values
      end
    end
  end
end