
  class Array
    def select_first(params)
      self.each do |e|
        atr = params.values[0]
        return e if eval("e.atr") == v
      #  params.each do |k, v|
     #     print k, v
     #     return e if e.k == v
       # end
      end
    end
  end
