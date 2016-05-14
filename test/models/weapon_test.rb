require 'test_helper'

class WeaponTest < ActiveSupport::TestCase
  setup do
    @hawkmoon = weapons :hawkmoon
  end

  test 'fixtures are valid' do
    assert @hawkmoon.valid?
  end
end
