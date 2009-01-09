require 'digest/md5'
class User < ActiveRecord::Base
  SALT = "hogehoge"
  before_create :create_cookie_id
  
  def create_cookie_id
    salt = User::SALT
    md5 = Digest::MD5::new
    now = Time::now
    md5.update(now.to_s)
    md5.update(String(now.usec))
    md5.update(String(rand(0)))
    md5.update(String($$))
    md5.update(salt)
    self.cookie = md5.hexdigest
  end
end
