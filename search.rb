require_relative './app/search_attachments'
require_relative './app/search_summary'

query = ARGV[0]
SearchAttachments.new(query).print_result
SearchSummary.new.summarize
