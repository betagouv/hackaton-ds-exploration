require 'json'

class JsonHandler
  DATA_PATH = '../20240901041013-demarches.json'

  def initialize
    file = File.read(DATA_PATH)
    @data = JSON.parse(file)    
  end

  def write_json(filename, content)
    File.open(sanitize_filename(filename), 'w') do |f|
      f.write(JSON.pretty_generate(content))
    end
  end

  def sanitize_filename(filename)
    filename.split('/').map{|f| sanitize_filename_part(f)}.join('/')
  end

  def sanitize_filename_part(filename)
    filename = filename.gsub('\s', ' ')
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
    return fn.join '.'
  end
end
