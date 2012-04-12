module BarelySearchable
  class Railtie < Rails::Railtie
    config.to_prepare do
      ::ActiveRecord::Base.send(:load, 'barely_searchable/model_injections.rb')
      ::ActiveRecord::Base.send(:include, BarelySearchable::ModelInjections)
    end
  end
end

