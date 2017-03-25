require 'test_helper'

class NotesInterfaceTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:michael)
  end

  test "note interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
    assert_select 'input[type=file]'
  	# 無効な送信
  	assert_no_difference 'Note.count' do
  		post notes_path, params: { note: { content: "" } }
  	end
  	assert_select 'div.error_explanation'
  	# 有効な送信
  	content = "This note really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
  	assert_difference 'Note.count', 1 do
  		post notes_path, params: { note: { content: content, picture: picture } }
  	end
  	assert_redirected_to root_url
    note = assigns(:note)
    assert note.picture?
  	follow_redirect!
  	assert_match content, response.body
  	# 投稿を削除する
  	assert_select 'a', text: 'delete'
  	first_note = @user.notes.paginate(page: 1).first
  	assert_difference 'Note.count', -1 do
  		delete note_path(first_note)
  	end
  	# 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
  	get user_path(users(:archer))
  	assert_select 'a', text: 'delete', count: 0
  end

  test "note sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.notes.count} notes", response.body
    # まだnoteを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 notes", response.body
    other_user.notes.create!(content: "A micropost")
    get root_path
    assert_match "1 note", response.body
  end
end
