class Array
  def select_first(args)
    do_select(args) do |e|
      return e
    end
  end
  
  def select_all(args)
    result = []
    do_select(args) do |e|
      result.push(e)
    end
    result
  end
  
  def do_select(args)
    if args.size == 1
      args = Array(args)[0]
      atr = args[0]
      values = Array(args[1])
      
      self.each do |e|
        values.each do |value|
          if eval("e.#{atr}") == value
            yield e
          end
        end
      end
      []  # If no element matching the select criteria were found, return the empty list
    elsif args.size == 2
      atr_name = args[:name]
      min = args[:interval][:min]
      max = args[:interval][:max]
  
      self.each do |e|
        atr = eval("e.#{atr_name}")
  
        if min != nil
          if atr >= min and atr <= max
            yield e
          end 
        elsif atr <= max
          yield e
        end
      end
    end
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
