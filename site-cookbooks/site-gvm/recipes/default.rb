#
# Cookbook Name:: site-gvm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w(curl git mercurial make binutils bison gcc).each do |pkg|
  package pkg do
    action :install
  end
end

template '/home/vagrant/.bash_profile' do
  mode 0644
end

bash 'install GVM' do
  user 'vagrant'
  group 'vagrant'
  environment 'HOME' => '/home/vagrant'
  code <<-EOH
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    source /home/vagrant/.gvm/scripts/gvm
    gvm install go1.4
    gvm use go1.4
    gvm install go1.5
    gvm use go1.5
  EOH
  not_if 'test -f /home/vagrant/.gvm/scripts/gvm'
end
