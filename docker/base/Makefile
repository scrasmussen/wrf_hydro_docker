tag=wrfhydro/dev:base

all: build

build:
	docker build -t ${tag} .

run:
	docker run -it ${tag}

deploy:
	docker push ${tag}
