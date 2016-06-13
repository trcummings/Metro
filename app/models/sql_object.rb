require_relative '../../lib/db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    unless @columns
      query = <<-SQL
        SELECT
          *
        FROM
          #{self.table_name}
      SQL

      result = DBConnection.execute2(query)
      @columns = result.first.map! { |col| col.to_sym }
    end

    @columns
  end

  def self.finalize!
    columns.each do |column|
      define_method column do
        attributes[column]
      end

      define_method "#{column}=".to_sym do |val|
        attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.all
    query = <<-SQL
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL

    results = DBConnection.execute(query)
    parse_all(results)
    # ...
  end

  def self.parse_all(results)
    results.map { |hash| self.new(hash) }
  end

  def self.find(id)
    query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = #{id}
    SQL

    results = DBConnection.execute(query)
    parse_all(results).first
  end

  def initialize(params = {})
    params.each_pair do |attr_name, value|
      attr_name = attr_name.to_sym

      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end

      self.send "#{attr_name}=".to_sym, value
    end
  end

  def attributes
    @attributes ||= {}
    # ...
  end

  def attribute_values
    self.class.columns.map { |col| send col.to_sym }
    # ...
  end

  def insert
    columns = self.class.columns
    question_marks = "(#{(["?"] * columns.length).join(", ")})"
    col_names = "(#{columns.join(", ")})"

    query = <<-SQL
      INSERT INTO
        #{self.class.table_name} #{col_names}
      VALUES
        #{question_marks}
    SQL

    DBConnection.execute(query, *attribute_values)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns
    set_line_array = columns.map { |col| "#{col} = ?" }
    where_line = set_line_array[0]
    set_line = set_line_array[1..-1].join(", ")
    attr_values = attribute_values[1..-1] + [attribute_values[0]]

    query = <<-SQL
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        #{where_line}
    SQL

    # debugger
    DBConnection.execute(query, *attr_values)
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
    # ...
  end
end
