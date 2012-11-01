module SQLGenerator

  def self.select(table,columns,conditions)
    raise ArgumentError 'Table must be specified' if table.nil? || table.empty?
    string = 'SELECT '
    if columns.nil? || columns.empty?
      string << '* '
    else
      columns.each do |column|
        string << "#{column}"
        string << (columns.last == column ? ' ' : ', ')
      end
    end
    string << "FROM #{table} "
    append_conditions(string,conditions)
    return string.rstrip
  end

  def self.insert(table,values)
    raise ArgumentError 'Table must be specified' if table.nil? || table.empty?
    raise ArgumentError 'Values must be specified' if values.nil? || values.empty?
    string = "INSERT INTO #{table} ("
    values.keys.each do |key|
      string << key
      string << (values.keys.last == key ? ')' : ',')
    end
    string << ' VALUES ('
    values.values.each do |value|
      string << "#{format_value(value)}"
      string << (values.values.last == value ? ')' : ',')
    end
    return string.rstrip
  end

  def self.update(table,values,conditions)
    raise ArgumentError 'Table must be specified' if table.nil? || table.empty?
    raise ArgumentError 'Values must be specified' if values.nil? || values.empty?
    string = "UPDATE #{table} SET "
    values.each do |key,value|
      string << "#{key}=#{format_value(value)}"
      string << (values.keys.last == key ? ' ' : ', ')
    end
    append_conditions(string,conditions)
    return string.rstrip
  end

  def self.delete(table,conditions)
    raise ArgumentError 'Table must be specified' if table.nil? || table.empty?
    raise ArgumentError 'Conditions must be specified' if conditions.nil? || conditions.empty?
    string = "DELETE FROM #{table} "
    append_conditions(string, conditions)
    return string.rstrip
  end

  def self.append_conditions(string,conditions)
    unless conditions.nil? || conditions.empty?
      string << "WHERE "
      conditions.each do |key,value|
        string << "#{key}=#{format_value(value)}"
        string << ' AND ' unless conditions.keys.last == key
      end
    end
    return string
  end

  def self.format_value(value)
    case value
    when String
      return "\'#{value}\'"
    when TrueClass
      return 1
    when FalseClass
      return 0
    else
      return value
    end
  end
end