#!/usr/bin/env ruby

require 'json'
require 'open-uri'

class UpdateGemInGemFile 

  VERSION = "0.0.2"
  GEMFILE = "./Gemfile"
  GEMFILE_CHECK = "./Gemfile.check"

  def initialize(gem_names)
    @gem_names = gem_names
  end

  def print_usage
    puts ""
    puts "Usage:"
    puts "#{$0} [gem_name] [another_gem_name]\n\n"
    puts "You can also define gem names in #{GEMFILE_CHECK} file:\n"
    puts "gem_name_1"
    puts "gem_name_2"
    puts ""
  end

  def read_gem_names_from_file
    gem_names = []
    File.open(GEMFILE_CHECK).each do |line|
      gem_names << line.strip
    end
    gem_names
  end

  def latest_gem_version(gem_name)
    uri = "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    json_body = JSON.load(open(uri, "User-Agent" => "update_gem_in_gemfile/#{VERSION} https://github.com/goodylabs/update_gem_in_gemfile"))
    return json_body['version']
  end

  def update_gem_version_in_gemfile(gem_name, latest_gem_version)
    gemfile = File.read(GEMFILE)
    new_gemfile_content = gemfile.gsub(/gem '#{gem_name}'.*$/, "gem '#{gem_name}', '= #{latest_gem_version}'")
    File.open(GEMFILE, "w") {|file| file.puts new_gemfile_content }
  end

  def perform
    if (@gem_names.nil? || @gem_names.empty?) && File.file?(GEMFILE_CHECK)
      @gem_names = read_gem_names_from_file
    elsif @gem_names.nil? || @gem_names.empty?
      print_usage
      exit 1;
    end

    @gem_names.each do |gem_name|
      latest_gem_version = latest_gem_version(gem_name)
      puts "Latest version of gem #{gem_name} is... #{latest_gem_version} "
      update_gem_version_in_gemfile(gem_name, latest_gem_version)
    end
    puts "\n"
    puts "#{GEMFILE} updated... [OK]\n"
    puts "Please do not forget to run: \n\n"
    puts "\tbundle install\n\n"
  end
end

UpdateGemInGemFile.new(ARGV).perform


