# frozen_string_literal: true

require "active_record_lazy_find_by/version"

module ActiveRecordLazyFindBy
  STATE_METHOD_NAMES = %i[valid? new_record? persisted?].freeze

  class << self
    def module_for(klass, attributes)
      lazy_attr_names = (klass.attribute_names - attributes.keys.map(&:to_s)).sort
      key = [klass, lazy_attr_names]

      cache[key] ||= build(lazy_attr_names)
    end

    def cache
      @cache ||= {}
    end

    private

    def build(attr_names)
      lazy_method_names = attr_names.flat_map { |x| [x, "#{x}?", "#{x}="] } + STATE_METHOD_NAMES

      Module.new do
        lazy_method_names.each do |m|
          define_method(m) do |*args|
            unless @lazy_new_record
              @lazy_new_record = true
              reload
            end
            super(*args)
          end
        end
      end
    end
  end

  module Methods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def lazy_find_by(attributes = {})
        mod = ActiveRecordLazyFindBy.module_for(self, attributes)
        new(attributes).extend(mod)
      end

      def lazy_find(id)
        lazy_find_by(id: id)
      end
    end
  end
end
