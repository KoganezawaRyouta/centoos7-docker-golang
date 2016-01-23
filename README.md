# Overview

## Install dependencies

* [vagrant(1.7.2)](https://www.vagrantup.com/downloads.html)
* [packer(0.7.5)](http://www.packer.io/downloads.html)


## vagrant plugins
```
vagrant plugin install vagrant-omnibus
vagrant plugin install sahara
vagrant plugin install vagrant-serverspec
```

## set up to gem
```
bundle install --path .bundle
```

## make box image
packer file from boxcutter
https://github.com/boxcutter/centos
https://github.com/eigo-s/packer_templates/tree/master/centos7.0/x86_64

```
packer build ./packer/centos71.json
vagrant box add --name centos71 packer/box/buyma-centos-7-1-x86-64-virtualbox.box
```


# 構築時のメモ
## レシピの下準備
### knife solo 初期化

```
bundle exec knife solo init .
```

### cookbooksのinstall
```
bundle exec berks vendor cookbooks
```

### 自前のcookbookを作成する場合
```
bundle exec knife cookbook create site-docker -o site-cookbooks/
bundle exec knife cookbook create site-nginx -o site-cookbooks/
bundle exec knife cookbook create site-gvm -o site-cookbooks/
```


run chef solo
```
# add ssh config
vagrant ssh-config --host=vagrant-centos-docker-golang >> ~/.ssh/config
bundle exec knife solo prepare vagrant-centos-docker-golang -i .vagrant/machines/default/virtualbox/private_key
bundle exec knife solo cook vagrant-centos-docker-golang -i .vagrant/machines/default/virtualbox/private_key
```



以下、レシピに追加する
### Enable Firewalld
```
sudo systemctl enable firewalld
```

## Start Firewalld
```
sudo systemctl start firewalld
```

### Check the Status of Firewalld
```
sudo systemctl status firewalld
```

### Webサーバー(http)のサービス（ポート）を永続的に許可
```
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="172.16.0.146" port protocol="tcp" port="9090" accept"
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

# ルールの追加
sudo firewall-cmd --direct --remove-rule="rule family="ipv4" source address="172.16.0.146" port protocol="tcp" port="9090" accept"

# ルールの削除
sudo firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="127.0.0.1" port port="9090" protocol="tcp" accept'
sudo firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="127.0.0.1" port port="1234" protocol="tcp" accept'
sudo firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="172.16.0.146" port port="9090" protocol="tcp" accept'
sudo firewall-cmd --zone=public --remove-rich-rule='rule family="ipv4" source address="172.16.0.146" port port="1234" protocol="tcp" accept'


sudo systemctl enable docker.service
sudo systemctl start docker.service
