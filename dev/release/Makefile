tag=wrfhydro/dev:v5.4.0

all: build

build:
	docker build -t ${tag} .

run:
	docker run -it ${tag}

deploy:
	docker push ${tag}
