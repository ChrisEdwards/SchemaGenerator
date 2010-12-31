class SqlGenerator

  attr_reader :database, :owner, :dest_folder

  def initialize(database, owner, dest_folder, options)
    @database    = database
    @owner       = owner
    @dest_folder = dest_folder
    @options     = options
  end


  def generate(sql_object)
    delete_existing_scripts(sql_object) if @options.is_clean_build?
    generate_sql(sql_object)
  end



  # Abstract methods
  # ----------------

  def generate_sql(sql_object)
    raise "must be implemented by a class"
  end


  def delete_existing_scripts(sql_object)
    raise "must be implemented by a class"
  end


  def object_type_name
    raise "must be implemented by a class"
  end

  

  # Helper methods
  # --------------

  # returns a fully qualified name
  def qualified(object_name)
    "#{@database}.#{@owner}.#{object_name}"
  end


  def escape_filename_for_glob(file_name)
    # Escape the following characters []{} since they are valid in a filename, but
    # they are also control chars for the glob function.
    file_name
      .gsub("[", "\\[")
      .gsub("]", "\\]")
      .gsub("{", "\\{")
      .gsub("}", "\\}")
  end


end
