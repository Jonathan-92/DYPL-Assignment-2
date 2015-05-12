class Array
  def select_first(params)
    if params.size == 1
      self.each do |e|
        params.each do |k, v|
          list = v
          if v.is_a?(String)
            list = v.split()
          end
          list.each do |i|
            if e.instance_variable_get("@#{k}") == i
              return e
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
            return e
          end
        elsif var <= max
          return e
        end
      end
    end
  end

  def select_all(params)
    
  end
end

