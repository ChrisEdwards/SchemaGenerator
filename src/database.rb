 class Database
  attr_accessor :name, :owner, :tables


  def initialize(name, owner)
    @name  = name
    @owner = owner
  end


  def load_yaml(source_folder)
    @tables = []
    count   = 0

    Log.text "\n\nReading table definitions".bright
    Log.text "=========================\n".bright
    Log.text "    Source folder: #{File.expand_path(source_folder)}\n\n"

    Dir["#{source_folder}/*.yml"].each do |table_file_name|
      Log.reading table_file_name

      ensure_file_has_no_tabs(table_file_name)

      tables = YAML.load_file(table_file_name)
      tables.each do |name, props|
        @tables << Table.new(name, self, props)
        count += 1
      end
    end

    Log.text "\n    #{count} table(s) read.\n\n"
  end


  def ensure_file_has_no_tabs(table_file_name)
    line_number = 1
    file        = File.new(table_file_name, "r")

    while (line = file.gets)
      if line.include?("\t")
        throw "Invalid TAB character found in [#{table_file_name}]. Line \##{line_number}. Please replace tabs with spaces in all yaml files."
      end
      line_number += 1
    end

    file.close
  end
end