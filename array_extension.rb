class Array
  def select_first(args)
    do_select(args) do |e|
      return e
    end
  end
  
  def select_all(args)
    result = []
      
    do_select(args) do |e|
      result << e
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
      []  # If no element matches the select criteria, return the empty list
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
    if name =~ /select_(first|all)_where_(.*)_is$/
      atr = $2
      Array.class_eval %(
        def #{name}(args)
          select_#{$1}(:#{atr} => args)
        end
      )
    elsif name =~ /select_(first|all)_where_(.*)_is_in/
      atr = $2
      Array.class_eval %(
        def #{name}(*args)
          args = args.flatten
          interval = args.size == 1 ? {:max => args[0]} : [:min,:max].zip(args).to_h
          select_#{$1}(:name => :#{atr}, :interval => interval)
        end
      )
    else
      super
    end
    
    send(name, args)
  end
end
