require File.expand_path(File.dirname(__FILE__) + '/sql_generator.rb')

class TableSqlGenerator < SqlGenerator


  def object_type_name
    "table"
  end


  private

  def generate_sql(table)
    generate_create_table_sql(table)
    1 # return that 1 script was created.
  end


  def delete_existing_scripts(table)
    # Does nothing since there is only one script, and writing the script file deletes the existing one.
  end


  def get_object_name(table)
    qualified table.name
  end


  def get_script_filename(table)
    object_name = get_object_name table
    File.join @dest_folder, "Create Table [#{object_name}].sql"
  end


  def generate_create_table_sql(table)

    qualified_table_name = get_object_name(table)
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
    file_name = get_script_filename table
    Log.writing file_name
    File.open(file_name, 'w') { |f| f.write(sql) }
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
    description += ' This is a calculated value.' if column.is_calculated?
    description += " This is a foreign key that references #{column.fk_table}.#{column.fk_column}. " if column.is_fk?
    description
  end
end