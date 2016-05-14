require 'test_helper'

class ValueTest < ActiveSupport::TestCase
  setup do
    @one = values :one
    @two = values :two
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
  end

  test 'relations' do
    assert_equal "Hard Luck Mk. 52", @one.item.name
    assert_equal "Hard Luck Mk. 52", @two.item.name

    assert_equal "Aim assistance", @one.stat.name
    assert_equal "Discipline", @two.stat.name
  end
end
