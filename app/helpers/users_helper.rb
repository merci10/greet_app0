module UsersHelper
  
  def image_for(user, size: 80)
  	if user.user_image
  	  image_tag "/user_images/#{user.user_image}", alt: user.name, width: size, class: "user-image"
  	else
  	  image_tag "320.png", width: size, class: "user-image"
  	end
  end
end