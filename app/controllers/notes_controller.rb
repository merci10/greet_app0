class NotesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@note = current_user.notes.build(note_params)
		if @note.save
			flash[:success] = "Note created!"
			redirect_to root_url
		else
  	  @feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@note.destroy
		flash[:success] = "Note deleted"
		redirect_to request.referrer || root_url
	end

	private

	  def note_params
	  	params.require(:note).permit(:content, :picture)
	  end

	  #投稿者本人か、noteは存在するか確認
	  def correct_user
	  	@note = current_user.notes.find_by(id: params[:id])
	  	redirect_to root_url if @note.nil?
	  end
end
