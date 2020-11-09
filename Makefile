include build/makefiles/makevars.mk
include build/makefiles/osvars.mk
include build/makefiles/buildvars.mk

build: services
	go build

setup:
	make -C tools_module

clean: clean_services

distclean: clean_services clean_tools

clean_tools:
	make -C tools_module clean

#
# Services: protobuf based service builds. Typically just add to SERVICES var.
#

APPLICATION := twirpql-play
SERVICES := hello

SERVICES_LIST := $(call join-with,$(comma),$(SERVICES))
TOOLS_BIN_DIR := tools_module/tools/bin
PROTOC := $(TOOLS_BIN_DIR)/protoc
PB_FILES := $(SERVICES:%=proto/%/service.pb.go)
TWIRP_FILES := $(SERVICES:%=proto/%/service.twirp.go)
TWIRPQL_FILES := $(SERVICES:%=proto/%/twirpql)
VALIDATOR_FILES := $(SERVICES:%=proto/%/service.validator.pb.go)
SWAGGER_FILES := $(SERVICES:%=swaggerui/proto/%/service.swagger.json)
STATIK := $(TOOLS_BIN_DIR)/statik
GOTPL := $(TOOLS_BIN_DIR)/gotpl

# Everything we build from a proto def
proto/%/service.pb.go \
proto/%/service.twirp.go \
proto/%/service.validator.pb.go \
swaggerui/proto/%/service.swagger.json \
  : proto/%/service.proto | swaggerui/proto
	PATH="$(TOOLS_BIN_DIR):$$PATH" $(PROTOC) \
            --proto_path=./proto \
            --proto_path=./tools_module/vendor \
            --proto_path=./tools_module/vendor/github.com/grpc-ecosystem/grpc-gateway \
            --go_out=./proto \
            --twirp_out=./proto \
            --govalidators_out=./proto \
            --twirp_swagger_out=./swaggerui/proto \
            $<

proto/%/twirpql : proto/%/service.proto
	cd $(@D) \
	&& PATH="../../$(TOOLS_BIN_DIR):$$PATH" ../../$(PROTOC) \
            --proto_path=../../tools_module/vendor \
            --proto_path=. \
            --twirpql_out=. \
            $(<F) \
	&& touch $(@F)

services: pb validator twirp twirpql swagger 

pb: $(PB_FILES)

validator: $(VALIDATOR_FILES)

twirp: $(TWIRP_FILES)

twirpql: pb twirp $(TWIRPQL_FILES)

swagger: swaggerui-statik/statik/statik.go

swaggerui-statik/statik/statik.go: swaggerui/index.html $(SWAGGER_FILES)
	$(STATIK) -f -src=swaggerui -dest=swaggerui-statik

swaggerui/proto:
	mkdir -v -p $@

swaggerui/index.html: swaggerui/index.html.tpl
	echo "{Application: $(APPLICATION), Services: [$(SERVICES_LIST)], CommitUrl: '$(COMMIT_URL)', Githash: $(GITHASH), RepoStatus: $(REPO_STATUS)}" | $(GOTPL) $< > $@

clean_services:
	rm -vf $(PB_FILES) $(TWIRP_FILES) $(VALIDATOR_FILES) $(SWAGGER_FILES)
	rm -rvf $(TWIRPQL_FILES)
	rm -vf swaggerui/index.html
	rm -rvf swaggerui/proto
