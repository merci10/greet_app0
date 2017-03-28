require 'test_helper'

class LikeTestTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  	@other = users(:archer)
  	@note = notes(:van)
  	log_in_as(@user)
  end

  test "like_notes page" do
  	get like_notes_user_path(@user)
  	assert_not @user.like_notes.empty?
  	assert_match @user.like_notes.count.to_s, response.body
  	@user.like_notes.each do |note|
  		assert_select "a[href=?]", user_path(note.user)
  	end
  end

  test "should like a note with the standard way" do
  	assert_difference '@user.like_notes.count', 1 do
  		post like_path(@note)
  	end
  end

  test "should like a note wiht Ajax" do
  	assert_difference '@user.like_notes.count', 1 do
  		post like_path(@note), xhr: true
  	end
  end

  test "should unlike a note with the standard way" do
  	@user.like(@note)
  	assert_difference '@user.like_notes.count', -1 do
  		delete unlike_path(@note)
  	end
  end

  test "should unlike a note with Ajax" do
  	@user.like(@note)
  	assert_difference '@user.like_notes.count', -1 do
  		delete unlike_path(@note), xhr: true
  	end
  end
end
