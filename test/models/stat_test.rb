require 'test_helper'

class StatTest < ActiveSupport::TestCase
  setup do
    @aimassist = stats :aimassist
    @discipline = stats :discipline
  end

  test 'fixtures are valid' do
    assert @aimassist.valid?
    assert @discipline.valid?
  end

  test 'relations' do
    assert_equal 115, @aimassist.values.first.maximum_value
    assert_equal 39, @discipline.values.first.minimum_value
  end
end
