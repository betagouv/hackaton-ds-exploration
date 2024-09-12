require_relative './app/search_attachments'
require_relative './app/search_non_attachments'
require_relative './app/search_summary'

query = ARGV[0]
option = ARGV[1]

if option
  SearchNonAttachments.new(query).print_result
else
  SearchAttachments.new(query).print_result
  SearchSummary.new.summarize
end
