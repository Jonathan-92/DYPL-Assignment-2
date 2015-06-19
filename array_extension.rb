class Array
  def select_first(args)
    do_select(args, false)
  end
  
  def select_all(args)
    do_select(args, true)
  end
  
  def do_select(args, select_all)
    result = []
    if args.size == 1
      self.each do |e|
        args.each do |k, v|
          
          # This will make sure v is always an Array, 
          # so that we can iterate over it
          v = [v].flatten
          
          v.each do |i|
            if e.instance_variable_get("@#{k}") == i
              if select_all
                result.push(e)
              else
                return e
              end
            end
          end
        end
      end
    elsif args.size == 2
      atr_name = args[:name]
      min = args[:interval][:min]
      max = args[:interval][:max]

      self.each do |e|
        atr = e.instance_variable_get("@#{atr_name}")

        if min != nil
          if atr >= min and atr <= max
            if select_all
              result.push(e)
            else
              return e
            end
          end
        elsif atr <= max
          if select_all
            result.push(e)
          else
            return e
          end
        end
      end
    end
    
    result
  end
    
  def method_missing(name, *args)
    if name =~ /select_(first|all)_where_(.*)_is(?:_in)?/
      atr = $2.to_sym
      Array.class_eval %(
        def #{name}(*args)
          select_#{$1}(:#{atr} => args.flatten)
        end
      )
      send(name, args)
    else
      super
    end
  end
end
