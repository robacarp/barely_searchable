module BarelySearchable
  module ModelInjections

    module ClassMethods
      def searches_on *fields, conditions
        if conditions.kind_of? Symbol
          fields.push conditions
          conditions = {}
        end

        conditions = {} if conditions.nil?

        if @searches.nil?
          init_searches_on
        end

        fields.map! {|field| [field, conditions]}
        @searches.push *fields
      end

      def init_searches_on
        @searches = []
      end

      def searches
        @searches
      end

      def search query, limit = nil
        where = '0'

        @searches.each do |search_field|
          field = search_field[0].to_s
          hash = search_field[1]

          #check to make sure the field actually exists on the table
          unless self.columns_hash.include? field
            raise NameError, "#{field} is not a valid column on #{self}"
          end

          #cast the query to the right data type for this column
          col_query = cast_to_column(query, field)

          #check for an if-condition
          next if ! hash[:if].nil? && ! hash[:if].call(col_query)

          #check for an unless condition
          next if ! hash[:unless].nil? && hash[:unless].call(col_query)

          if equality_columns.include? column_to_type(field)
            where += ' or ' + self.arel_table[field].eq( col_query ).to_sql
          else
            like = '%' + col_query.to_s.gsub(' ','%') + '%'
            where += ' or ' + self.arel_table[field].matches( like ).to_sql
          end
        end

        if limit.nil?
          self.where( where )
        else
          self.where( where ).limit( limit )
        end

      end

      private

      def cast_to_column data, column
        case column_to_type(column)
        when :decimal, :float
          data.to_f
        when :integer
          data.to_i
        when :string, :text, :binary, :date, :datetime, :time, :timestamp
          data.to_s
        when :boolean
          !!data
        else
          data
        end
      end

      def column_to_type column
        self.columns_hash[ column ].type
      end

      def equality_columns
        [:integer, :decimal, :float, :boolean]
      end

    end

    def self.included to
      to.extend ClassMethods
      to.init_searches_on
    end

  end
end
