module AttachmentsFilter
  USEFUL_FIELDS_TYPES = %w[RepetitionChampDescriptor PieceJustificativeChampDescriptor]

  def useful_field_type?(field_type)
    USEFUL_FIELDS_TYPES.include? field_type
  end
end