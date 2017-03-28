class LikesController < ApplicationController
	before_action :logged_in_user

	def create
		@note = Note.find(params[:note_id])
		current_user.like(@note)
		respond_to do |format|
 			format.html { redirect_to request.referrer || root_url }
 			format.js
 		end
	end

	def destroy
		@note = Note.find(params[:note_id])
		current_user.unlike(@note)
		respond_to do |format|
			format.html { redirect_to request.referrer || root_url }
			format.js
		end
	end
end
