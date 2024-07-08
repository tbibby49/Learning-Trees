require "application_system_test_case"

class BlossomsTest < ApplicationSystemTestCase
  setup do
    @blossom = blossoms(:one)
  end

  test "visiting the index" do
    visit blossoms_url
    assert_selector "h1", text: "Blossoms"
  end

  test "should create blossom" do
    visit blossoms_url
    click_on "New blossom"

    fill_in "Branch", with: @blossom.branch_id
    fill_in "Column", with: @blossom.column
    fill_in "Description", with: @blossom.description
    fill_in "Name", with: @blossom.name
    fill_in "Position", with: @blossom.position
    fill_in "Row", with: @blossom.row
    click_on "Create Blossom"

    assert_text "Blossom was successfully created"
    click_on "Back"
  end

  test "should update Blossom" do
    visit blossom_url(@blossom)
    click_on "Edit this blossom", match: :first

    fill_in "Branch", with: @blossom.branch_id
    fill_in "Column", with: @blossom.column
    fill_in "Description", with: @blossom.description
    fill_in "Name", with: @blossom.name
    fill_in "Position", with: @blossom.position
    fill_in "Row", with: @blossom.row
    click_on "Update Blossom"

    assert_text "Blossom was successfully updated"
    click_on "Back"
  end

  test "should destroy Blossom" do
    visit blossom_url(@blossom)
    click_on "Destroy this blossom", match: :first

    assert_text "Blossom was successfully destroyed"
  end
end
