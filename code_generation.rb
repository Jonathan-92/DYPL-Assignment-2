module Model

  def Model.generate(file_path)
    open(file_path) do |file|
      file.each_line do |line|
        eval(line.strip)
      end
    end

    define_attributes()
    define_load_from_file()
    $class
  end

  def Model.define_load_from_file()
    $class.class_eval %(
      def self.load_from_file(file_name)
        Model.load_from_file(self, file_name)
      end
    )
  end

  def Model.load_from_file(the_class, file_name)
    require 'yaml'
    data = YAML.load_file(file_name)['tests']
    objects = []
    
    data.each do |item|
      object = the_class.new
      
      begin
        the_class.attributes.each_key do |atr|
          eval("object.#{atr} = item[atr.to_s]")
        end
      rescue RuntimeError
        next
      end
      
      objects << object
    end
    
    objects
  end
  
  def Model.define_attributes()
    $class.attributes.each do |name, constraints|
      $class.class_eval %(
        attr_reader :#{name}

        def #{name}=(#{name})
          #{constraints}.each do |e|
            if not eval(e)
              raise 'Wrongful update when updating #{name}. Was ' + 
                  eval("#{name}").to_s + '; should be according to \"' + e + '\"'
            end
          end
          @#{name} = #{name}
        end
      )
    end
  end

  def Model.title(name)
    eval("class #{name}
      @@attributes = {}
      def self.attributes
        @@attributes
      end
    end")
    $class = eval("#{name}")
  end

  def Model.attribute(name, type)
    $class.attributes[name] = ["#{name}.class == #{type}"]
  end

  def Model.constraint(attribute, condition)
    $class.attributes[attribute] << condition
  end
end
