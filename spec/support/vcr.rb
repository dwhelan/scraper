require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.join(Dir.pwd, 'spec', 'vcr')
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end