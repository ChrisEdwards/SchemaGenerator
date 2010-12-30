class SqlGenerator
  # returns a fully qualified name
  def qualified(object_name)
    "#{@database}.#{@owner}.#{object_name}"
  end


  def escape_filename_for_glob(file_name)
    file_name.gsub("[", "\\[").gsub("]", "\\]").gsub("{", "\\{").gsub("}", "\\}")
  end


  private

  def initialize(database, owner, dest_folder, options)
    @database    = database
    @owner       = owner
    @dest_folder = dest_folder
    @options     = options
  end
end
