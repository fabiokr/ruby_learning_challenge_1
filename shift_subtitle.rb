require 'optparse'
require 'lib/subtitle'

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: shift_subtitle [-o -t] input_file output_file"

  options[:operation] = false
  opts.on( '-o', '--operation OPP', 'The operation type (currently supports only "add")' ) do |o|
    options[:operation] = o
  end

  options[:time] = false
  opts.on( '-t', '--time TIME', 'The time value to apply within the operation (-o) on the format 00:00:00,000 (this accepts a partial value like "2,500" or "12:12,000")' ) do |t|
    options[:time] = t
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

continue = true

if !options[:operation]
  continue = false
  puts "Missing the operation option (-o)"
elsif !options[:time]
  continue = false
  puts "Missing the time option (-t)"
elsif ARGV[0].nil?
  continue = false
  puts "Missing the input file"
elsif ARGV[1].nil?
  continue = false
  puts "Missing the output file"
end

if continue
  case options[:operation]
    when 'add'
      subtitle = Subtitle.new(ARGV[0])
      subtitle.add(options[:time])
      subtitle.save(ARGV[1])
  end
end

