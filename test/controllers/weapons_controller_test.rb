require 'test_helper'

class WeaponsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to '/auto_rifles'
  end
end
