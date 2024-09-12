require_relative './search_fields'

class SearchAttachments < SearchFields
  USEFUL_FIELDS_TYPES = %w[RepetitionChampDescriptor PieceJustificativeChampDescriptor]

  def useful_field_type?(field_type)
    USEFUL_FIELDS_TYPES.include? field_type
  end

  def print_result
    write_json("search_attachments/#{@query}.json", @result)

    puts "#{@result[:results_count]} résultats"
  end
end