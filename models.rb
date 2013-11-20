class User < ActiveRecord::Base

  def full_name
    if fname && lname
      fname + ' ' + lname
    elsif fname
      fname
    elsif lname
      lname
    else
      nil
    end
  end

  attr_accessor :password

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  #we have to replicate the password using the password salt and the supplied password
  #run the password they gave us along with their stored password salt
  #through the hash_secret method of the bcrypt engine.
  #if it matches the stored password_hash, then their password is correct

  #create this is a class method
  def self.authenticate(email, password)
    user = User.where(email: email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  has_many :tweets
end

class Tweet < ActiveRecord::Base

  belongs_to :user
end