require 'optparse'
require 'ostruct'
require 'trollop'


class Options

  attr_accessor :tables, :config_file, :clean_build

  SUB_COMMANDS = %w(scaffold sql)
  @@version    = "schemagen 1.0.0"
  @@banner     = <<-EOS


#{@@version}
SchemaGen generates clean sql schema creation scripts for tables and their related objects from yaml definition files.

Usage: schemagen.rb <subcommand> [options]

Available subcommands:
   scaffold    Generate folder structure and config file for a new database
   sql         Generate sql create scripts for tables and related objects

   Type 'schemagen.rb <subcommand> --help' for help on a specific subcommand.

Global options:
  EOS


  def self.parse2(args)
    global_opts = Trollop::options do
      version @@version
      banner @@banner
      stop_on SUB_COMMANDS
    end

    cmd         = ARGV.shift # get the sub-command.
    cmd_opts    = case cmd

                    when "scaffold" # parse scaffolding options
                      Trollop::options do
                        banner "Generates the folder structure and initial config file for a new database schema.\n\nOptions:"
                        opt :database, "The name of the database to generate scaffolding for.", :short => "-d"
                      end

                    when "sql" # parse sql generation options
                      Trollop::options do
                        banner "Generates sql scripts to create tables and related objects.\n\nOptions:"
                        opt :config_file, "Use the specified config file.", {:short => "-c", :default => 'config.yml'}
                        opt :tables, "List of tables to process. (Default: all tables)", :type=>:string
                      end

                    else
                      Trollop::die "unknown sub-command #{cmd.inspect}"

                  end
  end


  def self.parse(args)

    # Declare options and set defaults.
    options             = Options.new
    options.tables      = []
    options.config_file = 'config.yml'
    options.clean_build = false

    # Parse the options.
    parser              = OptionParser.new do |p|
      p.banner = "Usage: generate_schema.rb [options]"

      p.separator ""
      p.separator "Options:"

      p.on("-c", "--config FILE", "Use the specified config file. Default is 'config.yml' in the current folder.") do |config_file|
        options.config_file = config_file
      end

      p.on("-t", "--tables x,y,z", Array, "List of tables to process. Default is all tables.") do |tables|
        options.tables = tables
      end

      p.on("--clean", "Deletes all existing sql scripts prior to generating new ones.") do
        options.clean_build = true
      end


      p.on_tail("-h", "--help", "Show this message") do
        puts p
        exit
      end
    end


    parser.parse!(args)
    options

  end

  def is_clean_build?
    @clean_build
  end

end