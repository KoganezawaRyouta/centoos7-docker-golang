#
# Cookbook Name:: site-nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template '/etc/yum.repos.d/nginx.repo' do
  owner 'root'
  group 'root'
  mode '0644'
end

package 'nginx' do
  action :install
  options '--enablerepo=nginx'
end

template 'nginx.conf' do
  path '/etc/nginx/nginx.conf'
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[nginx]'
end

template 'vhosts.conf' do
  path '/etc/nginx/conf.d/vhosts.conf'
  source 'vhosts.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[nginx]'
end

service 'nginx' do
  action [:enable, :start]
  supports start: true, status: true, restart: true, reload: true
end
