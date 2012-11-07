
require 'open3'
require File.expand_path(File.join(File.dirname(__FILE__),'../../../unix-crypt/lib/unix_crypt'))

Puppet::Type.type(:pureftpd_user).provide(:puredb) do

  desc "Manage PureDB user for the Pure-ftpd"

  defaultfor :kernel => 'Linux'

  commands :pure_pw => 'pure-pw'

  # def self.
  #   raise ArgumentError, "sdfds"
  #   options = {
  #               :name       => {
  #                                 :regexp => /login/i
  #                              },
  #               :dir        => {
  #                                 :regexp => /directory/i,
  #                                 :proc => Proc.new do |raw|
  #                                   raw[/(.*)\/\.\/$/,1].strip
  #                                 end
  #                              },
  #               :uid        => {
  #                                 :regexp => /uid/i,
  #                                 :proc => Proc.new do |raw|
  #                                   begin
  #                                     raw.split(/\W/).first.to_i
  #                                   rescue
  #                                     nil
  #                                   end
  #                                 end
  #                              },
  #               :gid        => {
  #                                :regexp => /gid/i,
  #                                 :proc => Proc.new do |raw|
  #                                   begin
  #                                     raw.split(/\W/).first.to_i
  #                                   rescue
  #                                     nil
  #                                   end
  #                                 end
  #                               },
  #               :password   => {
  #                                :regexp => /password/i
  #                              }
  #              }
  #   default_proc = Proc.new { |raw| raw.strip }

  #   users = pure_pw('list').split("\n").map { |el| el.split(/\W/).first }

  #   users.map do |user|
  #     raw_output = pure_pw('show',user).split("\n").map { |el| el.split(":") }

  #     treated_options = options.reduce(Hash.new) do |acc,ar|
  #       handler = if options[ar.first][:proc]
  #                   options[ar.first][:proc]
  #                 else
  #                   default_proc
  #                 end

  #       handler.call(raw_output.detect { |el| el.first =~ options[ar.first][:regexp] }.last)
  #     end

  #     new(treated_options)
  #   end
  # end


  def gid=(desired)
    pure_pw(:usermod,resource[:name],'-g',desired)
  end

  def uid=(desired)
    pure_pw(:usermod,resource[:name],'-u',desired)
  end

  def dir=(desired)
    pure_pw(:usermod,resource[:name],'-d',desired)
  end

  def password=(desired)
    pin,pout,perr = Open3.popen3("pure-pw passwd #{@resource[:name]}")
    pin.puts(desired)
    pin.puts(desired)
  end

  def password
    pure_pw(:show, @resource[:name]).split("\n").map { |el| el.split(':') }.reject(&:empty?).detect { |el| el.first.strip =~ /password/i }.last.strip
  end

  def uid
    pure_pw(:show, @resource[:name]).split("\n").map { |el| el.split(':') }.reject(&:empty?).detect { |el| el.first.strip =~ /uid/i }.last.strip[/^\d+/]
  end


  def gid
    pure_pw(:show, @resource[:name]).split("\n").map { |el| el.split(':') }.reject(&:empty?).detect { |el| el.first.strip =~ /gid/i }.last.strip[/^\d+/]
  end

  def dir
    pure_pw(:show, @resource[:name]).split("\n").map { |el| el.split(':') }.reject(&:empty?).detect { |el| el.first.strip =~ /directory/i }.last.strip[/(.*)\/\.\/$/,1]
  end

  def password_insync?(current,desired)
    UnixCrypt.valid?(desired,current)
  end

  def create
    pin,pout,perr = Open3.popen3("pure-pw useradd #{@resource[:name]} -u #{@resource[:uid]} -g #{@resource[:uid]} -d #{@resource[:dir]}")
    pin.puts(@resource[:password])
    pin.puts(@resource[:password])
  end

  def destroy
    pure_pw(:userdel,@resource[:name])
  end

  def exists?
    if File.exist?('/etc/pure-ftpd/pureftpd.passwd')
      !!pure_pw(:list).split("\n").map { |el| el.split(/\s+/).first }.detect { |el| el.strip == @resource[:name] }
    else
      false
    end
  end

  def flush
    pure_pw(:mkdb)
  end

end

