IMAGE_NAME    ?= jlinoff/ssh-server-centos6
ROOT_PASS     ?= "root"
USER_NAME     ?= "dev"
USER_PASS     ?= "dev"
RFC_3339_DATE := $(shell date +%Y-%m-%dT%T%z)

.PHONY: all build clean info test \
	test-help \
	test-version test-version-v test-version-vv \
	test-info \
	test-bash test-bash-vv \
	test-install

all: build

build:
	docker build -f Dockerfile -t $(IMAGE_NAME) . \
		--build-arg "ROOT_PASS=$(CONT_ROOT_PASS)" \
		--build-arg "USER_NAME=$(USER_NAME)" \
		--build-arg "USER_PASS=$(USER_PASS)" \
		--label=build-date="$(RFC_3339_DATE)"

clean:
	find . -type f -name '*~' -delete
	docker rmi -f $(IMAGE_NAME)

info:
	docker inspect $(IMAGE_NAME) | grep '"Labels"' -A 5 | head -5

test: test-install

test-help:
	docker run --rm -i -t --init \
		-h $@ --name $@ \
		-P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		--help

test-version:
	docker run --rm -i -t --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		--version

test-version-v:
	docker run --rm -i -t --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		-v --version

test-version-vv:
	docker run --rm -i -t --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		-vv --version

# Verify that interactive access works.
test-bash:
	docker run --rm -i -t --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		/bin/bash -l

# Show interactive access with verbose messages.
test-bash-vv:
	docker run --rm -i -t --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		-vv /bin/bash -l

# Verify that remote access works.
test-install:
	docker run --rm -d --init -h $@ --name $@ -P \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		sleep 60
	docker exec -it $@ sudo yum install -y htop
	docker exec -it $@ which htop

# Verify that password-less ssh login works.
# Note that -vv does not display anything in
# detached mode.
test-install-ssh:
	[ ! -f id_rsa.pub ] && cp ~/.ssh/id_rsa.pub . || true
	docker run --rm -d --init -h $@ --name $@ \
		-p 2222:22 \
		-v $$(pwd):/mnt/share \
		$(IMAGE_NAME) \
		--key /mnt/share/id_rsa.pub sleep 60
	cat -n id_rsa.pub
	docker exec -it $@ cat -n /home/dev/.ssh/authorized_keys
	docker exec -it $@ ls -l /mnt/share
	ssh -p 2222 dev@localhost uptime
