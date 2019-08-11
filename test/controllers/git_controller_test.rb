require 'test_helper'

class GitControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get git_index_url
    assert_response :success
  end

  test "should get search" do
    get git_search_url
    assert_response :success
  end

end
