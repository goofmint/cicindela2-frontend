# Put your code that runs your task inside the do_work method
# it will be run automatically in a thread. You have access to
# all of your rails models if you set load_rails to true in the
# config file. You also get @logger inside of this class by default.
require 'open-uri'
require 'rubygems'
require 'hpricot'
class TitleWorker < BackgrounDRb::Rails
  
  def do_work(args)
    # This method is called in it's own new thread when you
    # call new worker. args is set to :args
    doc = Hpricot(open(args[:url]))
    title = doc.search("title").inner_text
    title = "No title" if title.blank?
    @url = Url.find :first, :conditions => ['url = ?', args[:url]]
    if @url
      @url.title = title
      @url.save
    end
  end
end
