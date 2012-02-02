require File.dirname(__FILE__) + '/lib/hashToCS.rb'
require 'fileutils'
  
class Package < Thor::Group
  include Thor::Actions
  # thor package <app>
  argument :app, :type => :string, :description => "specifies which application to build"

  desc "builds app source ready for release, and package it into the app directory"

  attr_accessor :package_dir, :output_dir, :input_dir

  def setup
    @input_dir = File.dirname(__FILE__) + '/build/.'
    @package_dir = File.dirname(__FILE__) + '/package/' 
    @output_dir = @package_dir + app
  end

  def build
    puts 'building...'
    thor :build, app
    puts "middleman building #{app} ..."
    `middleman build`
  end

  def copy_to_package_dir
    puts "copying built app to ./#{app}/ ..."
    Dir.mkdir(@package_dir) unless File.directory?(@package_dir)
    FileUtils.rm_rf @output_dir if File.directory?(@output_dir)
    Dir.mkdir(@output_dir)
    FileUtils.cp_r(@input_dir, @output_dir)
  end

  def done
    puts 'Done!'
  end

end