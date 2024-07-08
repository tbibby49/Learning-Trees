require "test_helper"

class BlossomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blossom = blossoms(:one)
  end

  test "should get index" do
    get blossoms_url
    assert_response :success
  end

  test "should get new" do
    get new_blossom_url
    assert_response :success
  end

  test "should create blossom" do
    assert_difference("Blossom.count") do
      post blossoms_url, params: { blossom: { branch_id: @blossom.branch_id, column: @blossom.column, description: @blossom.description, name: @blossom.name, position: @blossom.position, row: @blossom.row } }
    end

    assert_redirected_to blossom_url(Blossom.last)
  end

  test "should show blossom" do
    get blossom_url(@blossom)
    assert_response :success
  end

  test "should get edit" do
    get edit_blossom_url(@blossom)
    assert_response :success
  end

  test "should update blossom" do
    patch blossom_url(@blossom), params: { blossom: { branch_id: @blossom.branch_id, column: @blossom.column, description: @blossom.description, name: @blossom.name, position: @blossom.position, row: @blossom.row } }
    assert_redirected_to blossom_url(@blossom)
  end

  test "should destroy blossom" do
    assert_difference("Blossom.count", -1) do
      delete blossom_url(@blossom)
    end

    assert_redirected_to blossoms_url
  end
end
