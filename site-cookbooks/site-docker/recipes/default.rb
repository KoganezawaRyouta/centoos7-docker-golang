#
# Cookbook Name:: site-docker
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'docker' do
  action :install
end

bash 'install docker-compose' do
  user 'root'
  group 'root'
  code <<-EOH
    curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  EOH
  not_if 'test -f /usr/local/bin/docker-compose'
end
