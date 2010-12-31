require 'yaml'
require 'active_support/inflector'
require File.dirname(__FILE__) + '/Generator'
require 'rainbow'
require 'win32console'
require File.dirname(__FILE__) + '/Options'
require 'pp'

class String
  def escape_single_quotes
    self.gsub(/[']/, "''")
  end
end



# Script begins execution here.
# =============================
opts = Options.parse(ARGV)

puts "\nSchemaGen v0.0.1".bright
puts "http://github.com/ChrisEdwards/SchemaGenerator".bright

generator = Generator.new(opts)
generator.generate_scripts(opts.tables)

puts "\nGeneration complete.\n\n".color(:green).bright

