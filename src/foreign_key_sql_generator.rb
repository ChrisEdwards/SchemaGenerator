require File.expand_path(File.dirname(__FILE__) + '/sql_generator.rb')

class ForeignKeySqlGenerator < SqlGenerator


  def object_type_name
    "foreign key"
  end


  private

  def generate_sql(table)
    count = 0

    table.columns.values.each do |column|
      if column.is_fk? then
        generate_foreign_key_sql(table.db.name, table.name, column.name, column.fk_table, column.fk_column)
        count += 1
      end
    end

    count
  end


  def delete_existing_scripts(table)
    any_dest_table = '*' # mask to match foreign key scripts for any destination table.
    file_name_mask = get_script_filename(table.name, any_dest_table)
    file_name_mask = escape_filename_for_glob(file_name_mask)

    Dir.glob(file_name_mask).each do |file_name|
      Log.deleting file_name
      File.delete file_name
    end
  end


  def get_object_name(source_table, dest_table)
    "#{source_table}_ForeignKey_#{dest_table}"
  end


  def get_script_filename(source_table, dest_table)
    foreign_key_qualified_name = qualified(get_object_name(source_table, dest_table))
    File.join @dest_folder, "Create Foreign Key [#{foreign_key_qualified_name}].sql"
  end


  def generate_foreign_key_sql(db_name, source_table, source_column, dest_table, dest_column)

    foreign_key_name            = get_object_name source_table, dest_table
    source_table_qualified_name = qualified source_table
    dest_table_qualified_name   = qualified dest_table

    file_name                   = get_script_filename source_table, dest_table
    Log.writing file_name

    sql = <<EOF
-----------------------------------------------------------------------------------------
USE #{db_name}
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


end