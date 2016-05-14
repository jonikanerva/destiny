require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @luck = items :luck
  end

  test 'fixtures are valid' do
    assert @luck.valid?
  end

  test 'relations' do
    assert_equal 2, @luck.values.count
    assert_equal 39, @luck.values.first.value
    assert_equal 115, @luck.values.second.maximum_value
  end
end
