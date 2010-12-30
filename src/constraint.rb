class Constraint
  attr_accessor :type, :columns


  def initialize(type, columns)
    @type    = type
    @columns = columns
  end

end