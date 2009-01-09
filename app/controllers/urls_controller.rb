require 'uri'
require 'net/http'
class UrlsController < ApplicationController
  def index
    if request.referer.nil? || request.referer.blank?
      return render
    end
    get_user
    get_url
    
    # Save to livedoor cicindela2
    @code = nil
    Net::HTTP.version_1_2
    Net::HTTP.start('rec.moongift.jp', 80) {|http|
      res = http.get("/cicindela/record?set=moongift&op=insert_pick&user_id=#{@user.id}&item_id=#{@url.id}")
      @code = res.code
    }
  end
  
  def recommend
    if request.referer.nil? || request.referer.blank?
      return render
    end
    get_url
    
    body = ""
    Net::HTTP.version_1_2
    Net::HTTP.start('rec.moongift.jp', 80) {|http|
      res = http.get("/cicindela/recommend?set=moongift&op=for_item&item_id=#{@url.id}")
      body = res.body
    }
    ary = body.split("\n")
    logger.debug "#{ary.size}"
  end
  
  private
  
  def get_url
    @url = Url.find(:first, :conditions => ['url = ?', request.referer])
    @url = Url.create!(:url => request.referer) unless @url
    # Get title on background.
    MiddleMan.new_worker(:class => :title_worker, :args => {:url => request.referer}) if @url.title.blank?
  end
  
  def get_user
    url = URI.parse(request.referer)
    @user = User.find(:first, :conditions => ['cookie = ? and domain = ?', cookies[:id], url.host]) if cookies[:id]
    @user = User.create!(:domain => url.host) unless @user
    cookies[:id] = { :value => @user.cookie, :expires => Time.now + 3.years}
  end
end
