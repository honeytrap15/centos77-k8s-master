VERSION:=0.1.2

package.box:
	vagrant package

release:
	vagrant cloud publish honeytrap15/centos77-k8s-master $(VERSION) virtualbox package.box
