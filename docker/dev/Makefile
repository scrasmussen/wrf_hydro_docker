tag=wrfhydro/dev:latest

all: build

build:
	docker build -t ${tag} .

run:
	docker run -it -p 8888:8888 ${tag}

deploy:
	docker push ${tag}
