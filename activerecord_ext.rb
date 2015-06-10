module ActiveRecord
  class Base

    def self.search(params={}, resource_scope = nil)
      self.record_search(params, resource_scope)
    end

    def self.record_search(params, resource_scope = nil)
      unused_keys = [ '_search', 'nd', 'rows', 'cols', 'page', 'sidx', 'sord', 'searchField',
                      'searchString', 'searchOper', 'searchOper', 'controller' ,'action', 'format',"return_value" ]
      params.delete_if{|key,val| unused_keys.include?(key) }

      scope = resource_scope || all
      params.each do |column, filter|
        if filter.is_a?(Array)
          scope = scope.where(column => filter)
        elsif column.match(/_dt|_at|_date$/)
          scope = scope.where(column => filter.db_format)
        elsif column.match(/_time$/)
          scope = scope.where(" #{column} LIKE '%#{filter.db_format}%' ")
        elsif column.match(/_id$/)
          scope = scope.where(column => filter)
        else
          scope = scope.where(" #{column} LIKE '%#{filter}%' ")
        end
      end
      scope
    end

  end

end

