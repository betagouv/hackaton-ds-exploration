require_relative './search_fields'
require_relative './attachments_filter'

class SearchAttachments < SearchFields
  include AttachmentsFilter

  def print_result
    write_json("search_attachments/#{@query}.json", @result)

    puts "#{@result[:results_count]} résultats"
  end
end