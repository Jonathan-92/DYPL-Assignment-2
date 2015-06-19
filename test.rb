require 'test/unit'

class TestGenerator < Test::Unit::TestCase
   load 'code_generation.rb'
   load 'array_extension.rb'
   @@person_class = Model::generate('./personage_test.txt')
   @@tp = Model::TestPerson.new
   
   def test_error
      assert_raise RuntimeError do
        @@tp.name = nil
      end
      assert_raise RuntimeError do
        @@tp.age = -334
      end
      assert_raise RuntimeError do
        @@tp.name = 'joh'
      end
      assert_raise RuntimeError do
        @@tp.name = 3
      end
      assert_raise RuntimeError do
        @@tp.age = "3"
      end
  end
  
  def test_success
    @@tp.name = "Joh"
    @@tp.age = 33
    
    assert_equal("Joh", @@tp.name)
    assert_equal(33, @@tp.age)
  end
  
  def test_select
    person_class = Model::generate('./personage_test.txt')
    array = person_class.load_from_file('entries_test.yml')
    jojje = array[0]
    assert_equal(jojje, array.select_first(:age => 26))
    
    person_class2 = Model::generate('./personage_test2.txt')
    array = person_class2.load_from_file('entries_test.yml')
    jojje = array[0]
    assert_equal(jojje, array.select_first(:qwe => 3))
  end
end