require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @foreign_key = options[:foreign_key] || "#{name.to_s}_id".to_sym
    @class_name = options[:class_name] || name.camelcase
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name = name, options = {})
    @name = name
    @self_class_name = self_class_name
    @foreign_key = options[:foreign_key] || "#{self_class_name.to_s}_id".downcase.to_sym
    @class_name = options[:class_name] || name.singularize.camelcase
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name.to_s, options)

    define_method name do
      options = self.class.assoc_options[name]

      foreign_key_value = self.send(options.foreign_key)
      return nil unless foreign_key_value

      query = <<-SQL
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.table_name}.#{options.primary_key} = #{foreign_key_value}
      SQL

      results = DBConnection.execute(query)
      options.model_class.parse_all(results).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name.to_s, options)

    define_method name do
      options = self.class.assoc_options[name]

      foreign_key_value = self.send(options.primary_key)
      return nil unless foreign_key_value

      query = <<-SQL
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.table_name}.#{options.foreign_key} = #{foreign_key_value}
      SQL

      results = DBConnection.execute(query)
      options.model_class.parse_all(results)
    end
  end

  def has_one_through(name, through_name, source_name)

    define_method name do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      # for clarity
      through_table = through_options.table_name
      through_p_key = through_options.primary_key
      through_f_key = through_options.foreign_key

      source_table = source_options.table_name
      source_p_key = source_options.primary_key
      source_f_key = source_options.foreign_key

      foreign_key_value = self.send(through_f_key)
      return nil unless foreign_key_value

      query = <<-SQL
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_f_key} = #{source_table}.#{source_p_key}
        WHERE
          #{through_table}.#{through_p_key} = #{foreign_key_value}
      SQL

      results = DBConnection.execute(query)

      source_options.model_class.parse_all(results).first
    end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
