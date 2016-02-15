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
    wget -O direnv https://github.com/direnv/direnv/releases/download/v2.6.0/direnv.linux-amd64
    chmod +x direnv
    cd direnv
    sudo make install
    sudo mv direnv /usr/local/bin/
    echo 'eval "$(direnv hook bash)"' >> /home/vagrant/.bashrc
  EOH
  not_if 'test -f /usr/local/bin/direnv'
end
