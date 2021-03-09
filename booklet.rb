require 'optparse'

Line = Struct.new(:number, :name, :discordId, :location, :quantityAndType)
regex = /^([0-9]*)(.+?)#([0-9]*)(.+?(?=\d))([\s\S]+)/
launch_args = {}

args_parser = OptionParser.new do |opts|
  opts.banner = "ruby booklet.rb -in INPUT -out OUTPUT"
  opts.on('-i', '--in InputFile', 'Input file') do |s|
    launch_args[:input] = s
  end
  opts.on('-o', '--out OutputFile', 'Output file') do |s|
    launch_args[:output] = s
  end
end

args_parser.parse!

models = []

File.readlines(launch_args[:input]).each do |line|
  trimmed = line.strip
  if trimmed.include? '＃'
    trimmed['＃'] = '#'
  end
  model = trimmed.match(regex) { |m| Line.new(*m.captures) }
  models << model
end

File.open(launch_args[:output], 'w') do |file|
  file.write("number,name,discordId,location,quantity,type\n")
  models.each do |model|
    quantity = model.quantityAndType.scan(/\d/).join('')
    type = model.quantityAndType.scan(/[a-zA-Z]/).join('')
    file.write "#{model.number.strip},#{model.name.strip},##{model.discordId.strip},#{model.location.strip},#{quantity},#{type}\n"
  end
end