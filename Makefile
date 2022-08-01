run: docker_pack backend

backend:
	go run .

serve:
	npx webpack serve \
		--compress \
		--static-serve-index \
		--static-directory ./docs \
		--no-hot \
		--no-client-overlay-warnings \
		--client-progress

.image:
	docker build . -t webpack -f webpack.dockerfile
	touch .image

webpack-bash: .image
	docker run -it --rm -v $(PWD):/hacking webpack:latest

docker_pack: .image docker_node_modules
	rm -rf ./web
	docker run \
	-it --rm \
	-v $(PWD):/hacking \
	-w /hacking \
	webpack:latest \
	make pack

pack:
	npx webpack

docker_lint: .image
	docker run \
	-it --rm \
	-v $(PWD):/hacking \
	-w /hacking \
	webpack:latest \
	make lint

lint:
	npx eslint ./src/

docker_node_modules: .image
	docker run \
	-it --rm \
	-v $(PWD):/hacking \
	-w /hacking \
	webpack:latest \
	make node_modules

node_modules:
	npm install

shell: .image
	docker run \
	-it --rm \
	-v $(PWD):/hacking \
	-w /hacking \
	-p 8080:8080 \
	webpack:latest \
	/bin/bash

clean-all: clean clean-deps clean-images

clean:
	rm -rf ./web/ || true

clean-deps:
	rm -rf ./node_modules/ || true

clean-images:
	docker rmi webpack || true
	rm ./.image || true