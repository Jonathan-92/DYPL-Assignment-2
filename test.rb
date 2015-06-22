require 'test/unit'

class TestGenerator < Test::Unit::TestCase
   load 'code_generation.rb'
   load 'array_extension.rb'
   
  def test_select
    person_class = Model::generate('./personage_test.txt')
    person_class2 = Model::generate('./personage_test2.txt')
    array = person_class.load_from_file('entries_test.yml')
    jojje = array[0]
  array.each {|e| puts e.name}
    assert_equal(jojje, array.select_first(:age => 29))
    assert_equal("Tobias", array.select_first(:age => -29).name)
    assert_equal( [], array.select_all_where_name_is( 'Marve Flexnes' ) )
  end
end