require 'yaml'

THEMES =  YAML.load_file('colorschemes.yml')

if ARGV.include? '-list'
  puts THEMES.keys
  exit 0
end

unless ARGV.include? '-set'
  puts "USAGE:\n\ttheme -set {theme_name}\n\ttheme -list"
  exit 1
end

theme_index = ARGV.index('-set') + 1
theme = ARGV[theme_index]

if theme.nil? || theme.empty?
  puts 'must provided a theme name'
  exit 1
end

if THEMES[theme].nil?
  puts 'theme not found'
  exit 1
end

config_path = File.join("#{ENV['HOME']}", '.config','alacritty','alacritty.yml')
CURRENT_CONFIG = YAML.load_file(config_path)
CURRENT_CONFIG['colors'] = THEMES.dig(theme, 'colors')

File.open(config_path, 'w') do |file|
  file.write CURRENT_CONFIG.to_yaml
end

exit 0
