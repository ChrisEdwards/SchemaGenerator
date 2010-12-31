require File.expand_path(File.dirname(__FILE__) + '/sql_generator.rb')

class SeedDataSqlGenerator < SqlGenerator


  def object_type_name
    "seed data"
  end


  private

  def generate_sql(table)
    if table.has_seed_data? then
      generate_seed_data_sql table
      1
    else
      0
    end
  end


  def delete_existing_scripts(table)
    file_name = get_script_filename(table)
    File.delete(file_name) if File.exists?(file_name)
  end


  def get_object_name(table)
    qualified table.name
  end


  def get_script_filename(table)
    object_name = get_object_name table
    File.join @dest_folder, "Load seed data for [#{object_name}].sql"
  end


  def generate_seed_data_sql(table)
    table_qualified_name = get_object_name(table)
    file_name            = get_script_filename(table)
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


end