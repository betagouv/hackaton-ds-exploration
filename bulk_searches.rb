require_relative './app/search_attachments'
require_relative './app/search_non_attachments'
require_relative './app/search_summary'
require 'csv'

csv_path = ARGV[0]
option = ARGV[1]

if option
  search_class = SearchNonAttachments
else
  search_class = SearchAttachments
end

bulk_searches = CSV.read(csv_path || "./bulk_searches.csv", headers: true, col_sep: ";")
search_instance = search_class.new

results = bulk_searches.map do |csv_row|
  human_readable_search = csv_row["search"]
  regex = csv_row["regex"]
  search_instance.perform(regex).print_result
end

SearchSummary.new.summarize

