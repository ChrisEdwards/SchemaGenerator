class Column

  attr_accessor :table, :name, :type, :primarykey, :fk_table, :fk_column, :required, :calculated, :description


  def initialize(name, table, props)
    throw("Encountered undefined column [#{name}]") unless props
    throw("Missing \'type\' attribute in column [#{name}]") unless props['type']
    throw("Missing \'description\' attribute in column [#{name}]") unless props['description']

    @name        = name
    @type        = props['type']
    @primarykey  = props.fetch('primarykey', false)
    @identity    = props.fetch('identity', false)
    @required    = props.fetch('required', false)
    @calculated  = props.fetch('calculated', false)
    @description = props['description']

    if props['references'] then
      @fk_table  = props['references']['table']
      @fk_column = props['references']['column']
    end
  end


  def is_fk?
    @fk_table ? true : false
  end


  def is_identity?
    @identity
  end


  def is_required?
    @required
  end


  def is_calculated?
    @calculated
  end


  def stringify_value(value)
    down_case_type_name = @type.downcase
    if down_case_type_name.include?("varchar") || down_case_type_name == 'date' || down_case_type_name == 'datetime' then
      return "\'#{value.to_s}\'"
    elsif down_case_type_name == 'bit' then
      return value ? 1 : 0
    else
      return value.to_s
    end
  end

end