docker_dirs:=dev/base dev/latest dev/release
deploy_dirs:=$(addprefix deploy-,$(docker_dirs))

all: build

build: docker

docker: $(docker_dirs)
$(docker_dirs):
	@echo "Entering directory $@"
	make -C $@ build

deploy: $(deploy_dirs)
$(deploy_dirs):
	dir=$(@:deploy-%=%); \
	echo "Entering directory $$dir"; \
	make -C $$dir deploy

run: run-latest
run-base:
	@cd dev/base && make run
run-latest:
	@cd dev/latest && make run
run-release:
	@cd dev/release && make run

clean:
	docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | \
	awk '$$1 ~ /^wrfhydro\/dev:/ {print}' | \
	xargs -r docker rmi -f

.PHONY: all build $(docker_dirs) deploy $(deploy_dirs)
