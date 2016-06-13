require_relative '../../lib/db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.map { |key, val| "#{key} = ?" }.join(" AND ")
    param_array = params.values.map { |item| item.to_s }

    query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    results = DBConnection.execute(query, *params.values)
    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
