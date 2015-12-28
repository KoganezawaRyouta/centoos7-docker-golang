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
