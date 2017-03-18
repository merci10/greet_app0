module UsersHelper
  
  def image_for(user)
  	if user.user_image
  	  image_tag "/user_images/#{user.user_image}", alt: user.name, class: "user-image"
  	else
  	  image_tag "320.png", class: "user-image"
  	end
  end
end