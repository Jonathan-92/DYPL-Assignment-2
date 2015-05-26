load 'code_generation.rb'
include Model
generate('./personage.txt')
tp = TestPerson.new
tp.name = 3
tp.age = 4
puts tp.name, tp.age