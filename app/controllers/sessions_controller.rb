class SessionsController < ApplicationController

  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	#authenticateメソッドはhas_secure_passwordを定義したことによって使えるようになったメソッド
  	#引数にpasswordを入れて、DBのdigestと照合させる
  	if @user && @user.authenticate(params[:session][:password])
  		log_in @user
  	  redirect_to @user
    else
      #エラーメッセージを作成する
      flash.now[:danger] = "Invalid email/password combination"
  	  render 'new'
  	end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
