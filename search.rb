require_relative './app/search_attachments'

query = ARGV[0]
SearchAttachments.new(query).print_result
