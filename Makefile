IMAGE:=base-image
VERSION:=2.0.0

docker:
	docker build -t $(IMAGE):$(VERSION) .
