require 'test_helper'

class Example::TestsControllerTest < ActionController::TestCase
  setup do
    @example_test = example_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:example_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create example_test" do
    assert_difference('Example::Test.count') do
      post :create, example_test: { name: @example_test.name }
    end

    assert_redirected_to example_test_path(assigns(:example_test))
  end

  test "should show example_test" do
    get :show, id: @example_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @example_test
    assert_response :success
  end

  test "should update example_test" do
    patch :update, id: @example_test, example_test: { name: @example_test.name }
    assert_redirected_to example_test_path(assigns(:example_test))
  end

  test "should destroy example_test" do
    assert_difference('Example::Test.count', -1) do
      delete :destroy, id: @example_test
    end

    assert_redirected_to example_tests_path
  end
end
