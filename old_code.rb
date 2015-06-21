
#in code_generation.rb in Model.define_attributes()
if eval("#{constraints.join(' && ')}")
            @#{name} = #{name}
          else
            raise 'Wrongful update for #{name}'
          end
          
          