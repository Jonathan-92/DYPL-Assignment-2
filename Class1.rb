atr = "name"
$constraints = ["name.class == String", "name != nil"]
#$conditions = constraints.join(' && ')
$title = "Class1"
class Class1
end 
eval("#{$title}").class_eval %(
  def #{atr}
    @#{atr}
  end
  
  def #{atr}=(#{atr})
    if eval(%{#{$constraints.join(' && ')}})
      @#{atr} = #{atr}
    else
      raise 'Wrongful update'    
    end
  end
)
c = Class1.new
c.name = 3
puts c.name