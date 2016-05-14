require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @luck = items :luck
  end

  test 'fixtures are valid' do
    assert @luck.valid?
  end
end
