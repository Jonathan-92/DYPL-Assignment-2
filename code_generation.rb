module Model
  $constraints = {}

  def generate(file_path)
    open(file_path) do |file|
      file.each_line do |line|
        eval(line.strip)
      end
    end
  end

  def set_constraints()

  end

  def title(name)
    $title = name
    eval("class #{name}; end")
  end

  def attribute(name, type)
    eval("#{$title}.class_eval %(
      def #{name}
        @#{name}
      end

      def #{name}=(value)
        if value.class == #{type}
          @#{name} = value
        else
          raise 'Wrong type. Was: ' + value.class.to_s + '. Should be: #{type}'
        end
      end
    )")
  end

  def constraint(attribute, condition)
#    values = [condition]
#    previous_conditions = constraints[attribute]
#    values.concat(previous_conditions) unless previous_conditions.nil?
#    $constraints[attribute] = values
  end
end
