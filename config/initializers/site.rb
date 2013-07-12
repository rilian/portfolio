# Load domain config, so other initializers will use it

%w(site.yml).each do |config_file|
  raise "#{config_file} absent! Please check out #{config_file}.example" unless File.exists?("#{::Rails.root}/config/#{config_file}")
end
