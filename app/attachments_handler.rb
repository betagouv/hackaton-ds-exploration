require_relative './json_handler'

class AttachmentsHandler < JsonHandler
  USEFUL_FIELDS_TYPES = %w[RepetitionChampDescriptor PieceJustificativeChampDescriptor]

  def initialize
    super
  end

  def useful_data
    @data.map do |d|
      orga = d['service'] ? d['service']['organisme'] : nil
      {
        id: d['number'],
        dossiersCount: d['dossiersCount'],
        title: d['title'],
        organisme: orga,
        link: "https://github.com/betagouv/hackaton-ds-exploration/blob/main/demarches/#{d['number']}.json",
        words: words_of_fields(d['revision']['champDescriptors'])
      }
    end
  end

  def words_of_fields(fields)
    fields.select do |cd|
      USEFUL_FIELDS_TYPES.include? cd['__typename'] || cd['champDescriptors']
    end.map{|cd| all_words_of(cd)}.flatten.uniq
  end

  def all_words_of(field_descriptor)
    first_level_words = words_of(field_descriptor)
    second_level_words = field_descriptor['champDescriptors'].map{|d| all_words_of(d)} if field_descriptor['champDescriptors']

    [first_level_words, second_level_words].flatten.compact
  end

  def words_of(field_descriptor)
    description = field_descriptor['description'] == "" ? nil : field_descriptor['description']
    [field_descriptor['label'], description]
  end
end