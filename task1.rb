
module Aop
  def self.included(mod)
    mod.extend RAop
  end
  module RAop
    def self.extended(base)
      base.instance_eval do
        def method_added(name)
          return if !@methods_before.keys.include? && @methods_after.keys.include? name 
          class_eval do
            unless method_defined?(:)
              define_method(:) do
              end
          end
        end
      end
    end
    def method_missing(meth, *args, &block)
      @methods_before ||= {}
      @methods_after ||= {}
      if meth.match /^before_/
           method_name = meth.gsub /^before_/,''
           @methods_before[method_name] ||= [] 
           @methods_before[method_name].push *args 
      end
      if meth.match /^after_/
          method_name = meth.gsub /^after_/,''
          @methods_after[method_name] ||= [] 
          @methods_after[method_name].push *args 
      end
    end

  end
end


class Abc
  include Aop
  before_method1 :method2, :method3
  after_method2 :method1
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


Abc.new
