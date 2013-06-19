Dir["#{Dir.pwd}/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |c|
  c.color_enabled = true
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.tty = true # enable color in watchr
end
