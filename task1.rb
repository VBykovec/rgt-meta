module Aop
  def self.included(mod)
    puts mod
  end
end

class Abc
  include Aop
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
