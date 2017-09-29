IMAGE=jlinoff/linuxcli
all: build

.PHONY: build test info push
build: Dockerfile runner.sh
	docker build -f Dockerfile --label=com.github.jlinoff.docker-images.linuxcli.build-date=$$(date +"%Y-%m-%dT%T%z") -t $(IMAGE):latest .

test:
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) pwd
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) ls -l
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) xz --version
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) tar --version
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) ssh -V
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) git --version

info:
	docker inspect $(IMAGE) | grep '"Labels"' -A 4

push:
	docker push $(IMAGE):latest
