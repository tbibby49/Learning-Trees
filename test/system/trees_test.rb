require "application_system_test_case"

class TreesTest < ApplicationSystemTestCase
  setup do
    @tree = trees(:one)
  end

  test "visiting the index" do
    visit trees_url
    assert_selector "h1", text: "Trees"
  end

  test "should create tree" do
    visit trees_url
    click_on "New tree"

    fill_in "Description", with: @tree.description
    fill_in "Name", with: @tree.name
    click_on "Create Tree"

    assert_text "Tree was successfully created"
    click_on "Back"
  end

  test "should update Tree" do
    visit tree_url(@tree)
    click_on "Edit this tree", match: :first

    fill_in "Description", with: @tree.description
    fill_in "Name", with: @tree.name
    click_on "Update Tree"

    assert_text "Tree was successfully updated"
    click_on "Back"
  end

  test "should destroy Tree" do
    visit tree_url(@tree)
    click_on "Destroy this tree", match: :first

    assert_text "Tree was successfully destroyed"
  end
end
