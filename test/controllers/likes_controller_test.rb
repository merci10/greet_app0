require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  
	def setup
		@note = notes(:orange)
	end

  test "create should require logged-in user" do
  	assert_no_difference 'Like.count' do
  		post like_path(@note)
  	end
  	assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
  	assert_no_difference 'Like.count' do
  		delete unlike_path(@note)
  	end
  	assert_redirected_to login_url
  end
end
