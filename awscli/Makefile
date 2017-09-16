ifndef S3OBJECT
  S3OBJECT="s3://dummy/path/to/object" #fill this in!
endif

IMAGE=jlinoff/awscli

.PHONY: all build test info push
all: build

build: Dockerfile runner.sh
	docker build -f Dockerfile \
		--label=com.github.jlinoff.docker-images.awscli.build-date=$$(date +"%Y-%m-%dT%T%z") \
		-t $(IMAGE):latest .

test:
	docker run -it --rm -v $$(pwd):/mnt/share -v ~/.boto:/etc/boto.cfg $(IMAGE) aws s3 ls $(S3OBJECT)

info:
	docker inspect $(IMAGE) | grep '"Labels"' -A 4

push:
	docker push $(IMAGE):latest
