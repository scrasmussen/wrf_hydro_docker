docker_dirs:=docker/base docker/dev docker/release
training_dirs:=training/ training/CostaRica training/Hawaii \
	training/Croton_coupled training/coupled_training

all: build

build: docker training

docker: $(docker_dirs)
training: $(training_dirs)

$(docker_dirs):
	@echo "Entering directory $@"
	@cd $@ && make build
$(training_dirs):
	@echo "Entering directory $@"
	@cd $@ && make build

deploy:


clean:

.PHONY: all build $(docker_dirs) $(training_dirs)
