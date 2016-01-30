#
# Cookbook Name:: site-direnv
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'install direnv' do
  user 'root'
  group 'root'
  code <<-EOH
    cd /tmp
    git clone https://github.com/direnv/direnv
    cd direnv
    make install
    rm -rf /tmp/direnv
    echo 'eval "$(direnv hook bash)"' >> /home/vagrant/.bashrc
  EOH
  not_if 'test -f /usr/local/bin/direnv'
end
