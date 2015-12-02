BOTDIR = $(shell pwd)
NAME = limnoria

all: pull run

pull:
	docker pull libcrack/limnoria

run:
	docker run -d --name $(NAME) -v $(BOTDIR):/var/supybot libcrack/limnoria supybot limnoria.conf

build:
	docker build --rm --tag=limnoria .

runbuild:
	docker run -d --name $(NAME) -v $(BOTDIR):/var/supybot limnoria supybot limnoria.conf

.PHONY: build run
.SILENT: build run
