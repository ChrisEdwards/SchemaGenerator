$LOAD_PATH << File.dirname(__FILE__) + '/.'
require 'Database'
require 'Table'
require 'Column'
require 'Constraint'
require 'Log'
require 'foreign_key_sql_generator'
require 'table_sql_generator'
require 'seed_data_sql_generator'

class Generator


  def initialize(options)
    @@options                = options

    config                   = YAML.load_file(options.config_file)
    @table_source_folder     = config['source_folders']['tables']
    @table_dest_folder       = config['destination_folders']['tables']
    @foreign_key_dest_folder = config['destination_folders']['foreign_keys']
    @seed_data_dest_folder   = config['destination_folders']['seed_data']

    # Validate folders exist.
    if !Dir.exists? @table_source_folder then
      throw "The specified table source folder does not exist:  #{@table_source_folder}"
    end
    if !Dir.exists? @table_dest_folder then
      throw "The specified table destination folder does not exist:  #{@table_source_folder}"
    end
    if !Dir.exists? @foreign_key_dest_folder then
      throw "The specified foreign key destination folder does not exist:  #{@table_source_folder}"
    end
    if !Dir.exists? @seed_data_dest_folder then
      throw "The specified seed data destination folder does not exist:  #{@table_source_folder}"
    end

    # Convert relative paths to absolute paths.
    @table_source_folder     = File.expand_path(@table_source_folder)
    @table_dest_folder       = File.expand_path(@table_dest_folder)
    @foreign_key_dest_folder = File.expand_path(@foreign_key_dest_folder)
    @seed_data_dest_folder   = File.expand_path(@seed_data_dest_folder)

    @database                = config['database']['name']
    @owner                   = config['database']['owner']

    @db                      = Database.new('HomeOfficeBilling', 'dbo')
    @db.load_yaml(@table_source_folder)

    # Instantiate Generators.
    @table_sql_generator       = TableSqlGenerator.new(@database, @owner, @table_dest_folder, options)
    @foreign_key_sql_generator = ForeignKeySqlGenerator.new(@database, @owner, @foreign_key_dest_folder, options)
    @seed_data_sql_generator   = SeedDataSqlGenerator.new(@database, @owner, @seed_data_dest_folder, options)

    @generators                = [@table_sql_generator, @foreign_key_sql_generator, @seed_data_sql_generator]
  end


  def generate_scripts(target_tables)
    @generators.each do |generator|
      count            = 0

      title            = "Generating #{generator.object_type_name} scripts."
      title_underscore = "=" * title.length
      Log.text "\n#{title}".bright
      Log.text "#{title_underscore}\n".bright
      Log.text "    Dest folder: #{generator.dest_folder}\n\n"

      get_tables_to_process(target_tables).each do |table|
        Log.scanning table.name
        count += generator.generate(table)
      end

      Log.text "\n    #{count} #{generator.object_type_name} script(s) generated.\n\n"
    end
  end


  def get_all_table_names
    @db.tables.collect { |t| t.name }
  end


  def get_tables_to_process(target_tables)
    # Process all tables if none were specified.
    target_tables = get_all_table_names() if target_tables.empty?

    @db.tables.select { |t| target_tables.include?(t.name) }
  end
end