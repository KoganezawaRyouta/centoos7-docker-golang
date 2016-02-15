#
# Cookbook Name:: site-mysql
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'remove mariadb' do
  user 'root'
  group 'root'
  code <<-EOC
    sudo yum remove -y mariadb-libs
  EOC
end

bash 'install mysql' do
  user 'root'
  group 'root'
  code <<-EOC
    sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    sudo yum -y install mysql-community-server
  EOC
end

bash 'make mysql.sock' do
  user 'root'
  group 'root'
  code <<-EOC
    sudo touch /var/lib/mysql/mysql.sock
    sudo chown mysql:mysql /var/lib/mysql/mysql.sock
  EOC
  not_if 'test -f /var/lib/mysql/mysql.sock'
end

template '/etc/my.cnf' do
  mode 0644
end

bash 'init mysql' do
  user 'root'
  group 'root'
  code <<-EOC
    sudo systemctl enable mysqld.service
    sudo systemctl restart mysqld.service
  EOC
  not_if 'sudo systemctl is-enabled mysqld.service | grep enabled'
end

bash 'create database by mysql' do
  user 'root'
  group 'root'
  cwd '/home/vagrant'
  environment 'HOME' => '/home/vagrant'
  code <<-EOC
    mysql -u root -e 'create database coincheck;'
  EOC
  not_if 'mysql -u root -e "show databases;" | grep coincheck'
end
