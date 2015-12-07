#
# Cookbook Name:: site-nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "/etc/yum.repos.d/nginx.repo" do
  owner "root"
  group "root"
  mode "0644"
end

package "nginx" do
  action :install
  options "--enablerepo=nginx"
end

service "nginx" do
  action [:enable, :start]
  supports :start => true, :status => true, :restart => true, :reload => true
end