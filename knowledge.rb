def attribute(attr_name, attr_value = nil, &block_given)
  if attr_name.is_a?(Symbol) || attr_name.is_a?(String)
    attribute_real attr_name, attr_value, &block_given
  end
  if attr_name.is_a? Hash
    attr_name.each do |key,val|
      attribute_real key,val, &block_given
    end
  end
end

def attribute_real(name, value = nil, &block)
  define_method name do
    if instance_variable_defined? "@#{name}"
      instance_variable_get "@#{name}" 
    else
      if block
        instance_eval &block
      else
        value
      end
    end
  end

  define_method "#{name}=" do |val|
    instance_variable_set "@#{name}", val
  end

  define_method "#{name}?" do
    !instance_eval("#{name}").nil?
  end
end
