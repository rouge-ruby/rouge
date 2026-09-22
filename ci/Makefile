CI_FILE ?= ../.forgejo/workflows/ruby.yml
ARCH ?= amd64

VERSION ?= $(shell ruby -r ./../lib/rouge/version.rb -e 'puts Rouge.version')
PACKAGE ?= codeberg.org/rouge-ruby/ci-runner

# notably NOT including Gemfile.lock, as it will differ between Ruby versions
.PHONY: build
build: tmp/ruby-versions.txt tmp/Gemfile tmp/rouge.gemspec tmp/lib/rouge/version.rb
	docker buildx build --platform linux/$(ARCH) -t $(PACKAGE):$(VERSION) -t $(PACKAGE):latest .

.PHONY: push
push: build
	@echo remember to docker login codeberg.org first
	docker push $(PACKAGE):$(VERSION)
	docker push $(PACKAGE):latest

# grab the ruby versions from the matrix definition. the last one will be the
# default ruby for jobs
tmp/ruby-versions.txt: $(CI_FILE)
	mkdir -p $(dir $@)
	ruby -r yaml -e 'puts YAML.load_file("$(CI_FILE)", aliases: true).dig("_variables", "ruby-versions")' > $@

# copy in needed files from the repo so the dockerfile doesn't have to reach into ../
tmp/%: ../%
	mkdir -p $(dir $@)
	cp $< $@
