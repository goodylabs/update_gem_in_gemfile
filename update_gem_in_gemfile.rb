#!/usr/bin/env ruby

require 'json'
require 'open-uri'

class UpdateGemInGemFile 

  GEMFILE = "./Gemfile"

  def initialize(gem_names)
    @gem_names = gem_names
  end

  def print_usage
    puts ""
    puts "Usage:"
    puts "#{$0} [gem_name] [another_gem_name]"
    puts ""
  end

  def latest_gem_version(gem_name)
    uri = "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    json_body = JSON.load(open(uri))
    return json_body['version']
  end

  def update_gem_version_in_gemfile(gem_name, latest_gem_version)
    gemfile = File.read(GEMFILE)
    new_gemfile_content = gemfile.gsub(/gem '#{gem_name}'.*$/, "gem '#{gem_name}', '= #{latest_gem_version}'")
    File.open(GEMFILE, "w") {|file| file.puts new_gemfile_content }
  end

  def perform
    if @gem_names.nil? || @gem_names.empty?
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


