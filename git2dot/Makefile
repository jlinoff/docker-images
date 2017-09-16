IMAGE=jlinoff/git2dot

.PHONY: all build test info push
all: build

build: Dockerfile runner.sh
	docker build -f Dockerfile \
		--label=com.github.jlinoff.docker-images.git2dot.build-date=$$(date +"%Y-%m-%dT%T%z") \
		-t $(IMAGE):latest .

test:
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) git2dot.py -h

info:
	docker inspect $(IMAGE) | grep '"Labels"' -A 4

push:
	docker push $(IMAGE):latest

