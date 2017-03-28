require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  
  def setup
  	@like = Like.new(user_id: users(:michael).id,
  		          note_id: notes(:orange).id)
  end

  test "should be valid" do
  	assert @like.valid?
  end

  test "should require a user id" do
  	@like.user_id = nil
  	assert_not @like.valid?
  end

  test "should require a note id" do
  	@like.note_id = nil
  	assert_not @like.valid?
  end
end
