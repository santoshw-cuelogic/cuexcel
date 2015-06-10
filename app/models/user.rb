class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    create! do |user|


      #raise auth.inspect
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["name"]
    end
  end

end
