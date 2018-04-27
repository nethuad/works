# 安装git 2.2
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc
yum install  gcc perl-ExtUtils-MakeMaker 
wget https://github.com/git/git/archive/v2.2.1.tar.gz
tar zxvf v2.2.1.tar.gz
cd git-2.2.1
make configure
./configure
make
make install

git --version