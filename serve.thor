require File.dirname(__FILE__) + '/lib/hashToCS.rb'
require 'fileutils'
  
class Serve < Thor::Group
  include Thor::Actions
  # thor serve <app>
  argument :app, :type => :string, :description => "specifies which application to build"

  desc "builds app source ready for release, and serves the middleman app"

  def build
    puts 'build...'
    thor :build, app
  end

  def serve
    puts "serve #{app} ..."
    exec "middleman server"
  end

end