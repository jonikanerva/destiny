require 'test_helper'

class AttributeTest < ActiveSupport::TestCase
  setup do
    @one = attributes :one
    @two = attributes :two
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
  end
end
