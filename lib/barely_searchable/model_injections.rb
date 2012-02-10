require 'ruby-debug'

module BarelySearchable
  module ModelInjections

    module ClassMethods
      def searches_on *fields
        if @searches.nil?
          init_searches_on
        end

        @searches << fields
        @searches.flatten!
      end

      def init_searches_on
        @searches = []
      end

      def search query, limit = nil
        where = '0'
        like = '%' + query.to_s.gsub(' ','%') + '%'

        @searches.each do |field|
          field = field.to_s
          unless self.columns_hash.include? field
            raise NameError, "#{field} is not a valid column on #{self}"
          end

          if [:integer, :decimal, :float].include? self.columns_hash[ field.to_s ].type
            where += ' or ' + self.arel_table[field].eq( query ).to_sql
          else
            where += ' or ' + self.arel_table[field].matches( like ).to_sql
          end
        end

        if limit.nil?
          self.where( where )
        else
          self.where( where ).limit( limit )
        end

      end
    end

    def self.included to
      to.extend ClassMethods
      to.init_searches_on
    end

  end
end
