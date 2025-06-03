
gws-up:
	./scripts/gws-up.sh
gws-down:
	./scripts/gws-down.sh
gws: gws-up

cpman-full:
	./scripts/cpman.sh

cpman-stop:
	./scripts/stop-cpman.sh
cpman-start:
	./scripts/start-cpman.sh
stop-cpman: cpman-stop
start-cpman: cpman-start

check-sp:
	./scripts/check-sp.sh

get-sp:
	./scripts/get-sp.sh

tfstate-up:
	./scripts/tfstate-up.sh

tfstate-down:
	./scripts/tfstate-down.sh

tfstate-check:
	./scripts/tfstate-check.sh

cpman-up:
	./scripts/cpman-up.sh

cpman: cpman-up

cpman-down:
	./scripts/cpman-down.sh

ssh-cpman:
	./scripts/ssh-cpman.sh
cpman-ssh: ssh-cpman

serial-cpman:
	./scripts/serial-cpman.sh

serial: serial-cpman
cpman-serial: serial-cpman

reader-up:
	./scripts/reader-up.sh

reader-down:
	./scripts/reader-down.sh

policy-up:
	./scripts/policy-up.sh
policy: policy-up

policy-down:
	./scripts/policy-down.sh

linux-up:
	./scripts/linux-up.sh

linux-down:
	./scripts/linux-down.sh

ssh-linux:
	./scripts/ssh-linux.sh

check-cpman: check-cpman-api
	
check-cpman-api:
	./scripts/check-cpman-api.sh 

vmss-up:
	./scripts/vmss-up.sh
vmss: vmss-up
vmss-ssh:
	./scripts/vmss-ssh.sh
ssh-vmss: vmss-ssh
vmss-down:
	./scripts/vmss-down.sh
vmss-list:
	./scripts/vmss-list.sh

linux-rt:
	./scripts/linux-rt.sh
watch-linux-rt:
	watch -d ./scripts/linux-rt.sh
linux-fwon:
	./scripts/linux-fwon.sh
linux-fwoff:
	./scripts/linux-fwoff.sh

cme:
	./scripts/cme.sh