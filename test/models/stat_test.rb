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
end
