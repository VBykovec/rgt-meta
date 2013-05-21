module Aop
  def self.included(mod)
    mod.extend RAop
  end
  module RAop
    def self.extended(base)
      base.instance_eval do
        def method_added(name)
          return if !@methods_before.keys.include?(name.to_s) && !@methods_after.keys.include?(name.to_s)
            unless method_defined?("original_#{name}")
              alias_method "original_#{name}", name
              define_method("#{name}_new") do
                methods_before = self.class.instance_variable_get '@methods_before'
                methods_after = self.class.instance_variable_get '@methods_after'
                if methods_before[name.to_s]
                  methods_before[name.to_s].each do |method|
                      self.send method
                  end
                end
                  self.send "original_#{name}"
                if methods_after[name.to_s]
                  methods_after[name.to_s].each do |method|
                      self.send method
                  end
                end
              end
              alias_method name, "#{name}_new"
          end
        end
      end
    end
    def method_missing(meth, *args, &block)
      if meth.match /^before_/
          unless instance_variable_defined "@methods_before"
           instance_variable_set "@methods_before", Hash.new([])
          end
          method_name = meth.to_s.gsub /^before_/,''
          instance_eval do
              @methods_before[method_name] = args 
          end
      end
      if meth.match /^after_/
          unless instance_variable_defined "@methods_after"
           instance_variable_set "@methods_after", Hash.new([])
          end

          method_name = meth.to_s.gsub /^after_/,''
          instance_eval do 
            @methods_after[method_name] = args 
          end
      end
    end
  end
end


class Abc
  include Aop
  after_method1 :method3
  before_method1 :method2, :method3, :method3
  after_method2 :method3
  def method1
    puts 'm1'
  end
  def method2
    puts 'm2'
  end
  def method3
    puts 'm3'
  end
end

z = Abc.new
z.method1

