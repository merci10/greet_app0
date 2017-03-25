require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
  	@note = notes(:orange)
  end

  test "should redirect create when not logged in" do	
  	assert_no_difference 'Note.count' do
  		post notes_path, params: { note: { content: "Lorem ipsum" } }
  	end
  	assert_redirected_to login_url
  end

  test "shoudl redirect destroy when not logged in" do
  	assert_no_difference 'Note.count' do
  		delete note_path(@note)
  	end
  	assert_redirected_to login_url
  end

  test "should redirect destroy for wrong note" do
    log_in_as(users(:michael))
    note = notes(:ants)
    assert_no_difference 'Note.count' do
      delete note_path(note)
    end
    assert_redirected_to root_url
  end
end
