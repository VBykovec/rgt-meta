def attribute(name, value = nil, &block)
    b= binding
    if name.is_a?(Symbol)|| name.is_a?(String)
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
    if name.is_a? Hash
        name.each do |key,val|
            define_method key do
                if instance_variable_defined? "@#{key}"
                    instance_variable_get "@#{key}" 
                else
                    if block
                        instance_eval &block
                    else
                        val
                    end
                end
            end
            define_method "#{key}=" do |valr|
              instance_variable_set "@#{key}", valr
            end
            define_method "#{key}?" do
              !instance_eval("#{key}").nil?
            end
        end
    end
end
