require 'json'
require_relative './attachments_handler'

class SearchAttachments < AttachmentsHandler
  def initialize(query)
    super()
    @query = query

    search_results = search(@query, useful_data)
    @result = {
      query: @query,
      results_count: search_results.count,
      total_dossiers_count: search_results.map{|r| r[:dossiersCount]}.sum,
      results: search_results.sort_by{|r| -r[:dossiersCount]}
    }
  end

  def search(regex, data)
    regex = /#{regex}/ if regex.is_a? String

    matched_data = data.select do |d|
      matched = false
      
      d[:words].each do |words| 
        if words.downcase =~ regex 
          matched = true
          break
        end
      end

      matched
    end.map do |d|
      d[:matchs] = d[:words].select{|words| words.downcase =~ regex }
      d.delete :words
      d
    end
  end

  def print_result
    write_json("search_attachments/#{@query}.json", @result)

    puts "#{@result[:results_count]} résultats"
  end
end