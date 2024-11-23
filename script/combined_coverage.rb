require 'simplecov'

SimpleCov.collate [
  'coverage/rspec/.resultset.json',
  'coverage/cucumber/.resultset.json'
] do
  coverage_dir 'coverage/merged'
end

puts "Combined coverage report generated at coverage/merged/index.html"