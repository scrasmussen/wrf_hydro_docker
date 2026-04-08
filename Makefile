docker_dirs:=dev/base dev/release dev/latest
deploy_dirs:=$(addprefix deploy-,$(docker_dirs))

all: build

build: docker
build-base: dev/base
build-release: dev/release
build-latest: dev/latest

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

list:
	docker images
	@echo ""
	docker ps -a

clean:
	containers=$$(docker ps -aq); \
	if [ -n "$$containers" ]; then \
		docker rm $$containers; \
	fi
	docker images --format '{{.ID}}' wrfhydro/dev | \
	sort -u | \
	xargs -r docker rmi -f

.PHONY: all build $(docker_dirs) deploy $(deploy_dirs)
