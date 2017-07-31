ROUGE_PORT=-p "9292:9292"

image:
	docker build . -t \
		rouge-dev

shell:
	docker run \
		--rm -it -v "${PWD}:/src" -w /src \
		--entrypoint /bin/bash \
		rouge-dev

test:
	docker run \
		--rm -it -v "${PWD}:/src" -w /src \
		--entrypoint rake \
		rouge-dev

server:
	docker run \
		--rm -it -v "${PWD}:/src" -w /src \
		${ROUGE_PORT} \
		rouge-dev
