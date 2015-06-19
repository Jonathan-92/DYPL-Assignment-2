module Model
  $attributes = {}

  def Model.generate(file_path)
    open(file_path) do |file|
      file.each_line do |line|
        eval(line.strip)
      end
    end

    define_attributes()
    load_from_file()
    eval("#{$title}")
  end

  def Model.load_from_file()
    eval("#{$title}.instance_eval %(
      def self.load_from_file(file_name)
        Model.load(file_name)
      end
    )")
  end

  def Model.load(file_name)
    require 'yaml'
    data = YAML.load_file(file_name)['tests']
    objects = []
    
    data.each do |item|
      begin
        object = eval("#{$title}").new
        item.each do |k, v|
          eval("object.#{k} = v")
        end
        objects << object
      rescue #Exception => ex
        next
      end
    end
    
    objects
  end

  def Model.define_attributes()
    attributes = eval("#{$title}").attributes
    attributes.each do |name, constraints|
      eval("#{$title}").class_eval %(
        def #{name}
          @#{name}
        end

        def #{name}=(#{name})
          if eval("#{constraints.join(' && ')}")
            @#{name} = #{name}
          else
            raise 'Wrongful update for #{name}, #{name.class}'
          end
        end
      )
    end
  end

  def Model.title(name)
    $title = name
    eval("class #{name}
      @@attributes = {}
      
      def self.attributes
        @@attributes
      end
    end")
  end

  def Model.attribute(name, type)
    eval("#{$title}").class_eval %(
      @@attributes[name] = ["#{name}.class == #{type}"]
    )
  end

  def Model.constraint(attribute, condition)
    eval("#{$title}").class_eval %(
      @@attributes[attribute].push(condition)
    )
  end
end
