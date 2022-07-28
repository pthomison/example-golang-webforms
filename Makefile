# run: docker_pack backend

# backend:
# 	go run . \
# 		--db-host localhost --db-user pthomison --db-name postgres --db-password "\"\"" \
# 		--reddit-username kubelet-bot \
# 		--reddit-password $(shell aws ssm get-parameter --name "/reddit/kubelet-bot-password" --with-decryption | jq -r '.Parameter.Value') \
# 		--reddit-id $(shell aws ssm get-parameter --name "/reddit/personal-testing-app/id" --with-decryption | jq -r '.Parameter.Value') \
# 		--reddit-secret $(shell aws ssm get-parameter --name "/reddit/personal-testing-app/secret" --with-decryption | jq -r '.Parameter.Value')

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

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