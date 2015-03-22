class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_races
  has_many :races, through: :user_races
    

  def self.koala(auth)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=name,picture")
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    @graph = Koala::Facebook::API.new(access_token)
    profile = @graph.get_object("me")
    user = User.where(:provider => "facebook", :uid => profile["id"]).first
    puts "====================================================================="  
    puts user.name
    puts "====================================================================="  

    if user
      user.access_token = access_token
      user.save
      return user
    else
      registered_user = User.where(:email => profile["email"]).first
      if registered_user
        return registered_user
      else
        user = User.create(name: profile["name"],
                            provider: "facebook",
                            uid: profile["id"],
                            email: profile["email"],
                            password: Devise.friendly_token[0,20],
                            access_token: access_token,
                          )
      end    
    end
  end

end
