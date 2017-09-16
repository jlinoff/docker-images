IMAGE=jlinoff/graphviz

.PHONY: all build test info push
all: build

build: Dockerfile runner.sh
	docker build -f Dockerfile \
		--label=com.github.jlinoff.docker-images.graphviz.build-date=$$(date +"%Y-%m-%dT%T%z") \
		-t $(IMAGE):latest .

clean:
	docker rmi -f $(IMAGE)

test:
	-docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) dot -h

version:
	docker run -it --rm --init -v $$(pwd):/mnt/share $(IMAGE) dot -V

info:
	docker inspect $(IMAGE) | grep '"Labels"' -A 4

push:
	docker push $(IMAGE):latest

