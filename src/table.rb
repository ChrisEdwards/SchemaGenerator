class Table
  attr_accessor :db, :name, :description, :columns, :constraints, :seed_data


  def initialize(name, db, props)
    @name        = name
    @db          = db
    @description = props.fetch('description', '')
    @columns     = {}
    @constraints = []

    if props['columns'] then
      props['columns'].each do |column_name, column_props|
        @columns[column_name] = Column.new(column_name, self, column_props)
      end
    end

    if props['constraints'] then
      props['constraints'].each do |constraint_type, field_sets|
        field_sets.each do |fields|
          @constraints << Constraint.new(constraint_type, fields)
        end
      end
    end

    @seed_data = props.fetch('seed_data', [])
  end


  def has_seed_data?
    !@seed_data.empty?
  end


  def has_identity?
    @columns.values.any? { |col| col.is_identity? }
  end


  def has_constraints?
    !@constraints.empty?
  end


  def primary_key_name
    #return @name.singularize + 'LocalId'
    primary_key_column.name
  end


  def primary_key_column
    @columns.values.first { |col| col.is_identity? }
  end
end