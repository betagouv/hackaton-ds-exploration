require_relative './fields_handler'

class AttachmentsHandler < FieldsHandler
  USEFUL_FIELDS_TYPES = %w[RepetitionChampDescriptor PieceJustificativeChampDescriptor]

  def initialize
    super
  end

  def useful_field_type?(field_type)
    USEFUL_FIELDS_TYPES.include? field_type
  end
end