
#
# Setup: protoc+plugins, other tools
#
# Note that go mod vendor will bring down *versioned* tools base on go.mod. Yay.
# We use tools_modeule/tools.go to trick go mod into getting our tools for local builds.
# See the following for inspiration:
#   https://github.com/golang/go/wiki/Modules#how-can-i-track-tool-dependencies-for-a-module
#   https://github.com/golang/go/issues/25922
#   https://github.com/go-modules-by-example/index/blob/master/010_tools/README.md
#   

include ../build/makefiles/osvars.mk

TOOLS_DIR := ./tools
TOOLS_BIN_DIR := $(TOOLS_DIR)/bin

#
# protoccol compiler
# ------------------
PB_VER := 3.13.0
PB_REL := https://github.com/protocolbuffers/protobuf/releases
PB_ZIP := protoc-$(PB_VER)-$(OS_PLATFORM).zip
PB_URL := $(PB_REL)/download/v$(PB_VER)/$(PB_ZIP)
PROTOC := $(TOOLS_BIN_DIR)/protoc

#
# tools and protoc plugins to be installed via go install
# -------------------------------------------------------
GO_TOOLS_SRC := github.com/golang/protobuf/protoc-gen-go \
                github.com/twitchtv/twirp/protoc-gen-twirp \
                github.com/mwitkow/go-proto-validators/protoc-gen-govalidators \
                github.com/elliots/protoc-gen-twirp_swagger \
                marwan.io/protoc-gen-twirpql \
                github.com/rakyll/statik \
                github.com/tsg/gotpl

GO_TOOLS_BIN := $(addprefix $(TOOLS_BIN_DIR), $(notdir $(GO_TOOLS_SRC)))
GO_TOOLS_MAKEFILE := .go_tools.mk


tools: $(PROTOC) go_tools_bin

$(PROTOC): | $(TOOLS_BIN_DIR)
	curl --location $(PB_URL) --output $(TOOLS_DIR)/$(PB_ZIP)
	unzip -o -d "$(TOOLS_DIR)" $(TOOLS_DIR)/$(PB_ZIP) && touch $@

go_tools_bin: vendor $(GO_TOOLS_MAKEFILE) | $(TOOLS_BIN_DIR)
	make -f $(GO_TOOLS_MAKEFILE)

vendor: tools.go go.mod
	go mod vendor

$(GO_TOOLS_MAKEFILE): Makefile
	./makedeps.sh $(TOOLS_BIN_DIR) go_tools_bin $(GO_TOOLS_SRC) >$@

$(TOOLS_BIN_DIR):
	mkdir -v -p $@

# clean
# -----
clean:
	rm -rf "$(TOOLS_DIR)" vendor $(GO_TOOLS_MAKEFILE)
