module NonAttachmentsFilter
  EXCLUDE_FIELD_TYPES = 'PieceJustificativeChampDescriptor'

  def useful_field_type?(field_type)
    field_type != EXCLUDE_FIELD_TYPES
  end
end