#!/usr/bin/ruby

#
# J2EE Environment info gatherer.
# Crude hack by Andrea Paolini <ap@nuxi.it>
# (c) 2012 Andrea Paolini. All Rights Reserved
# See LICENSE.txt file for usage terms.

require 'rubygems'
require 'sinatra'
require 'haml'
require 'java'
require 'fileutils'
require 'yaml'
require 'pp'
require "sinatra/cookies"

MAINTITLE = "J2EE Environment info"

# use Rack::Session::Cookie, :key => 'JSESSIONID'

#
# Helper / utility functions
#
helpers do

  def prettyprint(obj)
    if obj.is_a? String
      obj
    else
      PP.pp obj, dump = ""
      dump.chomp
    end
  end

end


# Work around issues for context root accessed without
# final / when deployed as war
get '' do
  redirect request.env['REQUEST_URI'] + '/'
end

get '/' do
  @links = [
    ['path'   ,  'Process PATH'],
    ['procenv',  'Unix Environment variables'],
    ['sysprops', 'Java System properties'],
    ['java.class.path', 'Java Class Path'],
    ['reqenv' ,  'Request Environment'],
    ['pwd'    ,  'Current Directory'],
    ['umask'  ,  'Umask'],
    ['datasource', 'Datasource Driver info'],
    ['readfile', 'Read a file from local FileSystem'],
    ['writefile', 'Try creating and writing to a local file'],
    ['readcookies', 'Cookies received from browser'],
    ['setjsessionid', 'Send a random JSESSIONID cookie']
  ]
  haml :index
end

get '/path' do
  @title = "PATH"
  @myarr = ENV["PATH"].split(":")
  haml :arrtable
end

get '/procenv' do
  @title = "Process environment"
  @myhash = ENV
  haml :hashtable
end

get '/sysprops' do
  @title = "Java System properties"
  @myhash = java.lang.System.getProperties.inject({}) do |a, e|
      a.merge({ e[0] => e[1] })
  end
  haml :hashtable
end

get '/sysprops.yaml' do
  @myhash = java.lang.System.getProperties.inject({}) do |a, e|
      a.merge({ e[0] => e[1] })
  end
  @myhash.to_yaml
end

get '/java.class.path' do
  @title = "Java Class Path"
  @myarr = java.lang.System.getProperties["java.class.path"].split(":")
  haml :arrtable
end

get '/reqenv' do
  @title = "Request Environment"
  @myhash = request.env
  haml :hashtable
end

get '/pwd' do
  @title = 'Current Directory'
  @myarr = Array.new
  @myarr[0] = FileUtils::pwd
  haml :arrtable
end

get '/umask' do
  @title = "Umask"
  @myarr = Array.new
  @myarr.push sprintf("%04o",File.umask)
  haml :arrtable
end

get '/datasource' do
  @title = "Datasource"
  jndi ||= ""
  haml :forminputjndi
end

post '/datasource' do
  import javax.naming.InitialContext
  import javax.naming.Context

  @title = "Datasource Driver Version"
  @myhash = {}

  datasource_jndi = params[:jndi]
  #datasource_jndi = "gate0Data"
  @myhash["Datasource"] = datasource_jndi

  begin
    ic = InitialContext.new
    data_source = ic.lookup(datasource_jndi)
    @myhash["Datasource lookup"] = data_source
    connection = data_source.getConnection
    @myhash["Connection"] =  connection
    dbmd = connection.getMetaData
    @myhash["Driver Name"] = dbmd.getDriverName
    @myhash["Driver Version"] =  dbmd.getDriverVersion
  rescue NativeException => ex
    return "ERROR: cannot find or open datasource '#{datasource_jndi}'. Error message is: #{ex.message}"
  ensure
    connection.close
  end
  haml :hashtable
end

get '/readfile' do
  @title = "Read a file"
  @filepath ||= "/etc/passwd"
  haml :forminputfile
end

post '/readfile' do
  filepath = params[:filepath]
  @title = "Contents of file #{filepath}"
  begin
    @filecontents =  File.open(filepath).read # Slurp in memory. Beware the OOM.
  rescue SystemCallError => e
    @filecontents = "Error accessing file: #{e.class} #{e.exception}"
  end
  haml :filecontents
end

get '/writefile' do
  @title = "Try creating this file"
  @filepath = ""
  haml :forminputfile
end

post '/writefile' do
  filepath = params[:filepath]
  @title = "Creation of file #{filepath}"
  begin
    @filecontents = "Creating #{filepath} ... "
    f = File.open(filepath, "w")
    @filecontents << "OK\n"
    @filecontents << "Writing on file... "
    f.puts "Test #{Time.now}"
    @filecontents << "OK\n"
    @filecontents << "Closing... "
    f.close
    @filecontents << "OK\n"
  rescue SystemCallError => e
    @filecontents << "\nERROR: #{e.class} #{e.exception}"
  end
  haml :filecontents
end

get '/setjsessionid' do
  @title = "Sent a JSESSIONID cookie"
  cookies[:JSESSIONID] = "jsessionid-#{Time.now.to_i}"
  @myhash = {}
  @myhash["JSESSIONID"] = cookies[:JSESSIONID]
  haml :hashtable
end

get '/readcookies' do
  @title = "Cookies received"
  @myhash = cookies
  haml :hashtable
end

## END
