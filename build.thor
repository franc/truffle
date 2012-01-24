require File.dirname(__FILE__) + '/lib/hashToCS.rb'
require 'fileutils'
  
class Build < Thor::Group
  # thor build <app>
  argument :app, :type => :string, :description => "specifies which application to build"

  desc "builds app source ready for release"

  attr_accessor :app_config, :output_dir, :javascipts_dir, :config_dir, :raw_dir

  def start_build
    puts "starting build of #{app}"
    @config_dir = File.dirname(__FILE__) + '/config'
    @output_dir = File.dirname(__FILE__) + '/source'
    @raw_dir = File.dirname(__FILE__) + '/raw'
    @javascripts_dir = @output_dir + "/javascripts"
  end

  def reset_source_dir
    puts "resetting source dir"
    #reset source dir
    FileUtils.rm_rf @output_dir if File.directory?(@output_dir)
    Dir.mkdir(@output_dir)
    puts "."
  end

  def copy_scripts
    puts "copy scripts"
    #copy raw application javascripts
    FileUtils.cp_r(@raw_dir + "/javascripts", @output_dir)
    #create symlink to lib/javascripts (don't want to copy this around the whole time)
    FileUtils.ln_s(@raw_dir + "/lib", @javascripts_dir + "/lib")
    puts "."
  end

  def copy_images
    puts "copy images"
    FileUtils.cp_r(@raw_dir + "/images", @output_dir)
    puts "."
  end

  def copy_template
    puts "copy template"
    FileUtils.cp([@raw_dir + "/layout.erb", @raw_dir + "/index.html.erb"], @output_dir)
    puts "."
  end

  def copy_stylesheets
    puts "copy stylesheets"
    Dir.mkdir(@output_dir + "/stylesheets")
    FileUtils.cp(@raw_dir + "/stylesheets/application.css.scss", @output_dir + "/stylesheets")
    if File.exists?(@raw_dir + "/stylesheets/#{app}.css.scss")
      FileUtils.cp(@raw_dir + "/stylesheets/#{app}.css.scss", @output_dir + "/stylesheets")
    end
    puts "."
  end


  def get_app_config
    puts "fetching config"
    conf = YAML::load( File.open(@config_dir + "/" + 'apps.yml') )
    @app_config = conf[app]
    puts "."
  end

  def create_json_data
    puts "creating coffeescript data files"
    @app_config.each_key do |data_type|
      puts "  creating " + @javascripts_dir + "/" + data_type + "_json.coffee"
      f = File.new(@javascripts_dir + "/" + data_type + "_json.coffee", "w")
      f.puts "root = exports ? this"
      f.puts "root."+data_type+"_data = ["
      proc = Proc.new do |output| 
        f.puts output
      end
      data_file = @config_dir + "/" + data_type + '.yml'
      data = {}
      if File.exists? data_file
        data = YAML::load( File.open(data_file) )
        app_specific_data = app_config[data_type]

        #merge app spec config into all data
        app_specific_data.each do |k, v|
          if v.is_a? Hash
            data[k].merge! v
          else
            data[k] = v
          end
        end
        
        #delete data that is not relevant to app
        data.delete_if do |k, v|
          app_specific_data[k].nil?
        end
      else
        data = app_config[data_type]
      end

      data.each do |identifier, data_hash|
        raise data_hash.to_json
        HashToCS.convert(data_hash, "  ", proc)
      end
      f.puts "]"
      f.close
      puts "  ."
    end
    puts "."
  end

  def done
    puts "done!"
  end

end