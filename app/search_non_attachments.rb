require_relative './search_fields'
require_relative './non_attachments_filter'

class SearchNonAttachments < SearchFields
  include NonAttachmentsFilter

  def print_result
    write_json("search_non_attachments/#{@query}.json", @result)

    puts "#{@result[:results_count]} résultats"
  end
end