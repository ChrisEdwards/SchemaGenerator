$LOAD_PATH << File.dirname(__FILE__) + '/.'
require 'Database'
require 'Table'
require 'Column'
require 'Constraint'
require 'Log'

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
    @table_source_folder = File.expand_path(@table_source_folder)
    @table_dest_folder = File.expand_path(@table_dest_folder)
    @foreign_key_dest_folder = File.expand_path(@foreign_key_dest_folder)
    @seed_data_dest_folder = File.expand_path(@seed_data_dest_folder)

    @database = config['database']['name']
    @owner    = config['database']['owner']

    @db       = Database.new('HomeOfficeBilling', 'dbo')
    @db.load_yaml(@table_source_folder)
  end


  def get_all_table_names
    @db.tables.collect { |t| t.name }
  end


  def get_tables_to_process(target_tables)
    # Process all tables if none were specified.
    target_tables = get_all_table_names() if target_tables.empty?

    @db.tables.select { |t| target_tables.include?(t.name) }
  end


  def generate_table_scripts(target_tables)
    count = 0

    Log.text "\nGenerating tables".bright
    Log.text "=================\n".bright
    Log.text "    Dest folder: #{File.expand_path(@table_dest_folder)}\n\n"

    get_tables_to_process(target_tables).each do |table|
      generate_create_table_sql(table)
      count += 1
    end

    Log.text "\n    #{count} table(s) generated.\n\n"
  end


  def generate_foreign_key_scripts(target_tables)
    count = 0

    Log.text "\nGenerating foreign keys".bright
    Log.text "======================\n".bright
    Log.text "    Dest folder: #{File.expand_path(@foreign_key_dest_folder)}\n\n"

    get_tables_to_process(target_tables).each do |table|
      delete_foreign_key_scripts(table.name) if @@options.is_clean_build?
      table.columns.values.each do |column|
        if column.is_fk? then
          generate_foreign_key_sql(table.name, column.name, column.fk_table, column.fk_column)
          count += 1
        end
      end
    end

    Log.text "\n    #{count} foreign key(s) generated.\n\n"
  end


  def escape_filename_for_glob(file_name)
    file_name
      .gsub("[", "\\[")
      .gsub("]", "\\]")
      .gsub("{", "\\{")
      .gsub("}", "\\}")
  end


  def delete_foreign_key_scripts(table_name)
    dest_table = '*' # mask for foreign keys of all destination tables.
    file_name_mask = get_foreign_key_filename(table_name, dest_table)

    # Escape the [ and ] we use in our filenames since they are glob reserved chars.
    file_name_mask = escape_filename_for_glob(file_name_mask)

    Dir.glob(file_name_mask).each do |file_name|
      Log.deleting file_name
      File.delete file_name
    end
  end


  def generate_seed_data_scripts(target_tables)
    count = 0

    Log.text "\nGenerating seed data scripts".bright
    Log.text "===========================\n".bright
    Log.text "    Dest folder: #{File.expand_path(@seed_data_dest_folder)}\n\n"


    get_tables_to_process(target_tables).each do |table|
      Log.scanning table.name
      if table.has_seed_data? then
        generate_seed_data_sql table
        count += 1
      end
    end

    Log.text "\n    #{count} seed data script(s) generated.\n\n"
  end


  def generate_seed_data_sql(table)
    table_qualified_name = "#{qualified table.name}"
    file_name            = "#{@seed_data_dest_folder}/Load seed data for [#{table_qualified_name}].sql"
    Log.writing file_name
    sql = <<EOF
---------------------------------------------------------------------------------------
USE #{@database}
GO
---------------------------------------------------------------------------------------
SET NOCOUNT ON
---------------------------------------------------------------------------------------
EOF
    table.seed_data.each do |row_data|
      pk_value       = row_data[table.primary_key_name]
      row_exists_sql = <<EOF
IF NOT EXISTS (SELECT 1 
                 FROM #{table_qualified_name}
                WHERE (#{table.primary_key_name} = #{pk_value})
              )
   BEGIN
      ---------------------------------------------------------------------------------
EOF
      sql += row_exists_sql

      if table.has_identity? then
        identity_on_sql = <<EOF
      SET IDENTITY_INSERT #{table.name} ON;
      ---------------------------------------------------------------------------------
EOF
        sql += identity_on_sql
      end
      column_values = []
      row_data.each do |column_name, column_value|
        column = table.columns[column_name]
        column_values << column.stringify_value(column_value)
      end

      insert_sql = <<EOF
      INSERT 
         INTO #{table_qualified_name}
             (#{row_data.keys.join("\n             ,")}
             )
       VALUES 
             (#{column_values.join("\n             ,")}
             );
      ---------------------------------------------------------------------------------
EOF
      sql += insert_sql

      if table.has_identity? then
        identity_off_sql = <<EOF
      SET IDENTITY_INSERT #{table.name} OFF;
      ---------------------------------------------------------------------------------
EOF
        sql += identity_off_sql
      end

      closing_sql = <<EOF
   END
---------------------------------------------------------------------------------------				
EOF
      sql += closing_sql
    end

    File.open(file_name, 'w') { |f| f.write(sql) }
  end


  def get_foreign_key_name(source_table, dest_table)
    "#{source_table}_ForeignKey_#{dest_table}"
  end


  def get_foreign_key_filename(source_table, dest_table)
    foreign_key_qualified_name = qualified( get_foreign_key_name(source_table, dest_table) )
    File.join @foreign_key_dest_folder, "Create Foreign Key [#{foreign_key_qualified_name}].sql"
  end


  def generate_foreign_key_sql(source_table, source_column, dest_table, dest_column)

    foreign_key_name            = get_foreign_key_name source_table, dest_table
    foreign_key_qualified_name  = qualified foreign_key_name
    source_table_qualified_name = qualified source_table
    dest_table_qualified_name   = qualified dest_table

    file_name                   = "#{@foreign_key_dest_folder}/Create Foreign Key [#{foreign_key_qualified_name}].sql"
    Log.writing file_name

    sql = <<EOF
-----------------------------------------------------------------------------------------
USE #{@database}
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: #{source_table} => #{dest_table}
-----------------------------------------------------------------------------------------
IF OBJECT_ID('#{foreign_key_name}') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: #{foreign_key_name}...',0,0) WITH NOWAIT;
      ALTER TABLE #{source_table_qualified_name}
         DROP CONSTRAINT #{foreign_key_name};
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: #{foreign_key_name}...',0,0) WITH NOWAIT;
ALTER TABLE #{source_table_qualified_name}
   ADD CONSTRAINT #{foreign_key_name}  FOREIGN KEY (#{source_column}) 
       REFERENCES #{dest_table_qualified_name} (#{dest_column});
GO
-----------------------------------------------------------------------------------------	
EOF

    File.open(file_name, 'w') { |f| f.write(sql) }
  end


  def generate_create_table_sql(table)

    qualified_table_name = qualified table.name
    primary_key_name     = "#{table.primary_key_name}"

    # Render sql header.
    sql                  = <<EOS
---------------------------------------------------------------------------------------
USE #{@database};
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('#{qualified_table_name}') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: #{qualified_table_name}...',0,0) WITH NOWAIT;
      DROP TABLE #{qualified_table_name};
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: #{qualified_table_name}...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE #{qualified_table_name}
(
EOS

    comma = ' '

    # Render the columns.
    table.columns.values.each do |column|

      column_name = column.name.ljust(50)
      type        = column.type.upcase.ljust(15)

      if column.is_identity?
        # Generate Identity
        null_or_identity = 'IDENTITY(1,1)'
      else
        # Generate Null/Not Null
        null_or_identity = column.is_required? ? 'NOT NULL' : '    NULL'
      end

      null_or_identity = null_or_identity.upcase.ljust(15)
      comment          = build_description(column)
      sql              += "#{comma}#{column_name} #{type} #{null_or_identity} -- #{comment}\n"
      comma            = ','
    end

    # Render the standard audit columns.
    audit_columns = <<EOS
	
 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT #{table.name}_Default_TimeInserted  
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT #{table.name}_Default_TimeUpdated
      DEFAULT    (GETDATE())
EOS
    sql                    += audit_columns


    # Render the primary key constraint.
    primary_key_constraint = <<EOS
	
 -- Constraints
,CONSTRAINT #{table.name}_PrimaryKey_#{primary_key_name}
      PRIMARY KEY CLUSTERED (#{primary_key_name} ASC)
EOS
    sql += primary_key_constraint


    # Render the unique key constraints.
    sql += generate_constraints_sql(table) if table.has_constraints?


    # Render the Table Description extended property.
    table_description_sql = <<EOS
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON #{qualified_table_name} TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'#{table.description.escape_single_quotes}'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'#{@owner}'
       ,@level1type=N'TABLE'
       ,@level1name=N'#{table.name}'
GO
EOS
    sql += table_description_sql


    # Render each Column Description extended property.
    table.columns.values.each do |column|

      extended_property_sql = <<EOS
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'#{build_description(column)}'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'#{@owner}'
       ,@level1type=N'TABLE'
       ,@level1name=N'#{table.name}'
       ,@level2type=N'COLUMN'
       ,@level2name=N'#{column.name}'
GO
EOS
      sql += extended_property_sql
    end

    # Render closing sql.
    closing_sql = <<EOS
---------------------------------------------------------------------------------------
GO
EOS
    sql       += closing_sql

    # Write the sql to the file.
    file_name = "#{@table_dest_folder}/Create Table [#{qualified_table_name}].sql"
    Log.writing file_name
    File.open(file_name, 'w') { |f| f.write(sql) }
  end


  # returns a fully qualified name
  def qualified(object_name)
    "#{@database}.#{@owner}.#{object_name}"
  end


  def generate_constraints_sql(table)
    # Render the unique key constraints.
    constraints_sql = ''
    table.constraints.each do |constraint|
      columns_asc    = constraint.columns.collect { |x| x + ' ASC' }
      constraint_sql = <<EOS

,CONSTRAINT #{table.name}_UniqueKey_#{constraint.columns.join('')} 
      UNIQUE NONCLUSTERED   (#{columns_asc.join(', ')})
EOS
      constraints_sql += constraint_sql
    end
    constraints_sql
  end


  def build_description(column)
    description = column.description.escape_single_quotes
    description += ' This value is calculated and populated by the billing system.' if column.is_calculated?
    description += " This is a foreign key that references #{column.fk_table}.#{column.fk_column}. " if column.is_fk?
    description
  end

end