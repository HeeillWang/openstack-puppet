# openstack-puppet
# version 1.0

This is for install openstack by Puppet.

We consider install liberty on CentOS 7.

To install Openstack, you need to edit answer.txt.

You need to write setting informations on answer.txt such as IP address, password, number of compute node that you want to install.

On version 1.0 you can only install openstack with one or zero compute node.

0 compute node means all-in-one.

Then, you can run Installer.sh which automatically install Openstack.


Installer.sh - Install all Openstack components and environments. 

Installer excute all shell-scripts on this repository except package.sh.
               
Puppet-install.sh - Install Puppet. This is automatically excuted by installer.

answer.txt - Setting informations that are needed on installation.

controller.sh - Install all Controller node components. This is automatically excuted by installer. Swift not included yet.

compute.sh - Install all Compute node components. This is automatically excuted by installer or remote_installer.sh

remote_installer.sh - Install compute node by using ssh. This is automatically excuted by installer only when install more than one  

compute node

storagenode/cinder - For install storagenode. On version 1.0 it is just considered as controller node component.


each components(rabbitmq, keystone, nova, neutron, horizion...etc) - For install each components. It is included corresponding

directory and excuted by them such as contorller.sh or compute.sh

package.sh - For install packages only. Basically you don't need to consider or excute it.

*for Korean :

Puppet을 이용하여 Openstack을 설치한다.

CentOS 7에서 liberty 버전을 설치하는 것을 상정하였다.

Openstack을 설치하기 위해 가장 먼저 answer.txt를 수정하여야 한다.

answer.txt에 IP주소, 비밀번호, 설치할 컴퓨트 노드의 개수 등을 작성한다.

버전 1.0에서는 컴퓨트노드를 0개 혹은 1개 설치하는 것만 가능하다.

0개의 컴퓨트 노드는 all-in-one 설치를 의미한다.

작성 후에, Installer.sh를 실행하면 Openstack이 자동적으로 설치된다.


installer.sh - Openstack의 모든 컴포넌트와 환경을 설치한다.

installer는 package.sh를 제외한 이 프로젝트의 모든 쉘을 호출하여 실행한다.
               
Puppet-install.sh - Puppet을 설치한다. insaller에 의해 호출된다.

answer.txt - 설치에 필요한 모든 설정 정보가 담겨 있다.

controller.sh - 컨트롤러 노드의 모든 컴포넌트를 설치한다. installer에 의해 호출된다. Swift는 아직 포함되지 않았다.

compute.sh - 컴퓨트 노드의 모든 컴포넌트를 설치한다. installer 혹은 remote_insaller에 의해 호출된다.

remote_installer.sh - 컴퓨트 노드를 ssh를 통해 원격으로 설치한다. 1개 이상의 컴퓨트 노드를 설치하는 경우에 한해 installer에 의해  

호출된다.

storagenode/cinder - 스토리지 노드를 설치한다. 버전 1.0에서는 컨트롤러 노드로 간주하여 설치한다.


each components(rabbitmq, keystone, nova, neutron, horizion... 등) - 각 컴포너트를 설치한다. 해당하는 폴더에 포함되어 있으며 해당하는

쉘에 의해 호출된다.(controller.sh, compute.sh 등)

package.sh - 패키지들만 설치한다. 일반적으로 신경쓸 필요 없고 실행할 필요도 없다.
