require File.dirname(__FILE__) + '/lib/hashToCS.rb'
require 'fileutils'
  
class Serve < Thor::Group
  # thor serve <app>
  argument :app, :type => :string, :description => "specifies which application to build"

  desc "builds app source ready for release,and serves the middleman app"

  #attr_accessor :app_config, :output_dir, :javascipts_dir, :config_dir, :raw_dir

  def build
    `thor build #{app}`
  end

  def serve
    `middleman server`
  end

end