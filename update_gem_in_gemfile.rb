#!/usr/bin/env ruby

require 'json'
require 'open-uri'

class UpdateGemInGemFile 

  GEMFILE = "./Gemfile"

  def initialize(gem_name)
    @gem_name = gem_name
  end

  def print_usage
    puts ""
    puts "Usage:"
    puts "#{$0} [gem name]"
    puts ""
  end

  def latest_gem_version(gem_name)
    uri = "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    json_body = JSON.load(open(uri))
    return json_body['version']
  end

  def update_gem_version_in_gemfile(latest_gem_version)
    gemfile = File.read(GEMFILE)
    new_gemfile_content = gemfile.gsub(/gem '#{@gem_name}'.*$/, "gem '#{@gem_name}', '= #{latest_gem_version}'")
    File.open(GEMFILE, "w") {|file| file.puts new_gemfile_content }
  end

  def perform
    if @gem_name.nil? || @gem_name.empty?
      print_usage
      exit 1;
    end

    latest_gem_version = latest_gem_version(@gem_name)
    puts "Latest version of gem #{@gem_name} is #{latest_gem_version} ..."
    update_gem_version_in_gemfile(latest_gem_version)

  end
end

UpdateGemInGemFile.new(ARGV[0]).perform


