# Overview

## Install dependencies

* [vagrant(1.7.2)](https://www.vagrantup.com/downloads.html)
* [packer(0.7.5)](http://www.packer.io/downloads.html)


## vagrant plugins
```
vagrant plugin install vagrant-omnibus
vagrant plugin install sahara
vagrant plugin install vagrant-serverspec
vagrant plugin install vagrant-vbguest
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
cd packer
packer build ./centos71.json
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
bundle exec knife cookbook create site-direnv -o site-cookbooks/
```


run chef solo
```
# add ssh config
vagrant up
↑Authentication failureでエラーになる場合
ssh-keygen -yf ~/.vagrant.d/insecure_private_key > .vagrant/machines/default/virtualbox/private_key
vagrant ssh
vi /home/vagrant/.ssh/authorized_keys # 生成した公開鍵を設定する

vagrant ssh-config --host=vagrant-centos-docker-golang >> ~/.ssh/config
bundle exec knife solo prepare vagrant-centos-docker-golang -i .vagrant/machines/default/virtualbox/private_key
bundle exec knife solo cook vagrant-centos-docker-golang -i .vagrant/machines/default/virtualbox/private_key
```

ここから先はただのメモ！！
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


## 下記エラーになる場合
```
Failed to mount folders in Linux guest. This is usually because
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly. The command attempted was:

mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` vagrant /vagrant
mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` vagrant /vagrant

The error output from the last command was:

/sbin/mount.vboxsf: mounting failed with the error: No such device
```

```
$ sudo yum -y update
$ sudo yum install -y kernel-devel gcc
$ sudo /etc/rc.d/init.d/vboxadd setup
```

```
$ vagrant reload --provision
```

## firewalld無効化
```
sudo systemctl stop firewalld
sudo systemctl mask firewalld
```

## hostsの設定
192.168.80.10 dev.koga.com

## アプリへアクセス
http://dev.koga.com/

mysql -h localhost -u web_app -p
