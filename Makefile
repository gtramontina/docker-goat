SHELL := bash -eu -o pipefail -c
.DELETE_ON_ERROR:

# ---

container-registry := ghcr.io
image-owner := gtramontina
image-name := goat
image := $(container-registry)/$(image-owner)/$(image-name)
tag = $(shell grep "blampe/goat" go.mod | cut -d' ' -f3)

# ---

build.log: go.sum Dockerfile Makefile
	@docker build --build-arg version=$(tag) -t $(image):$(tag) . | tee $@
to-clobber += $(image):$(tag)
to-clean += build.log

test.log: build.log
	grep -q "Usage of /goat" <<< `docker run --rm $(image):$(tag) -h 2>&1 >/dev/null`  | tee $@
to-clean += test.log

# ---

.PHONY: build
build: build.log

.PHONY: test
test: test.log

.PHONY: push
push: test
	@docker push $(image):$(tag)

.PHONY: clean
clean:; @rm -rf $(to-clean)

.PHONY: clobber
clobber: clean
	@docker rmi $(to-clobber) --force
