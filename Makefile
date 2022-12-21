.PHONY: build-prod
build-prod:
	docker build --platform linux/armv7 -t andreaswachs/wachswork:latest .

.PHONY: publish
publish: build-prod
	docker push andreaswachs/wachswork:latest