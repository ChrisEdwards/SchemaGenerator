require 'rainbow'
require 'win32console'

class Log

  def self.reading(file_name)
    puts "    reading    ".color(:cyan).bright + "#{File.basename(file_name)}".bright
  end


  def self.writing(file_name)
    puts '    writing    '.color(:green).bright + "   #{File.basename(file_name)}"
  end


  def self.scanning(file_name)
    puts '   scanning    '.color(:cyan).bright + file_name.bright
  end


  def self.text(text)
    puts text
  end


  def self.deleting(file_name)
    puts '   deleting    '.color(:red).bright + "   #{File.basename(file_name)}"
  end

end