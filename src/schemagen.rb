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
pp opts

generator = Generator.new(opts)

generator.generate_table_scripts(opts.tables)
generator.generate_foreign_key_scripts(opts.tables)
generator.generate_seed_data_scripts(opts.tables)

puts "\nGeneration complete.\n\n".color(:green).bright

