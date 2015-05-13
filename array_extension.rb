class Array
  def select_first(params)
    if params.size == 1
      atr = params.keys[0]
      values = params.values[0]
      self.each do |e|
        list = values
        if list.is_a?(String)
          list = list.split()
        end
        list.each do |i|
          if e.instance_variable_get("@#{atr}") == i
            return e
          end
        end
      end
    elsif params.size == 2
      atr = params[:name]
      min = params[:interval][:min]
      max = params[:interval][:max]

      self.each do |e|
        var = e.instance_variable_get("@#{atr}")

        if min != nil
          if var >= min and var <= max
            return e
          end
        elsif var <= max
          return e
        end
      end
    end
  end

  def select_all(params)
    result = []
    if params.size == 1
      self.each do |e|
        params.each do |k, v|
          list = v
          if v.is_a?(String)
            list = v.split()
          end
          list.each do |i|
            if e.instance_variable_get("@#{k}") == i
              result.push(e)
            end
          end
        end
      end
    elsif params.size == 2
      atr = params[:name]
      min = params[:interval][:min]
      max = params[:interval][:max]

      self.each do |e|
        var = e.instance_variable_get("@#{atr}")

        if min != nil
          if var >= min and var <= max
            result.push(e)
          end
        elsif var <= max
          result.push(e)
        end
      end
    end
    return result
  end

  def method_missing(name, *args)
    if (name =~ /select_(first|all)_where_(.*)_is/)
      atr = $2.to_sym
      Array.class_eval %(
        def #{name}(params)
          select_#{$1}(:#{atr} => params)
        end
      )
      #send(name, args)
      eval("select_#{$1}(:#{atr} => #{args})")
      #eval("#{name}(#{args})")
    else
      super
    end
  end
end

