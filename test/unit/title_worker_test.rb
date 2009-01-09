require File.dirname(__FILE__) + '/../test_helper'
require "#{RAILS_ROOT}/vendor/plugins/backgroundrb/backgroundrb.rb"
require "#{RAILS_ROOT}/lib/workers/title_worker"
require 'drb'

class TitleWorkerTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_truth
    assert TitleWorker.included_modules.include?(DRbUndumped)
  end
end
