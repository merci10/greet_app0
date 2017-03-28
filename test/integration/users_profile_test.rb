require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@user = users(:michael)
		@other = users(:archer)
		@note = notes(:van)
		log_in_as(@user)
	end

	test "profile display" do
		get user_path(@user)
		assert_template 'users/show'
		assert_select 'title', full_title(@user.name)
		assert_select 'h1', text: @user.name
		assert_select 'h1 > img.user-image'
		assert_match @user.notes.count.to_s, response.body
		assert_match @user.like_notes.count.to_s, response.body
		assert_select 'div.pagination', count: 1
		@user.notes.paginate(page: 1).each do |note|
			assert_match note.content, response.body
		end
		#自分のshowページにいる時
		@user.like(@note)
		assert_match @user.like_notes.count.to_s, response.body
		@user.unlike(@note)

		#@otherのshowページにいる時
		get user_path(@other)
		assert_template 'users/show'
		@user.like(@note)
		assert_match @other.like_notes.count.to_s, response.body
		@user.unlike(@note)
	end
end
