// +build tools

package tools

import (
	// protocol buffer compiler plugins
	_ "github.com/elliots/protoc-gen-twirp_swagger"
	_ "github.com/golang/protobuf/protoc-gen-go"
	_ "github.com/mwitkow/go-proto-validators/protoc-gen-govalidators"
	_ "github.com/twitchtv/twirp/protoc-gen-twirp"
	_ "marwan.io/protoc-gen-twirpql"

	// grpc-gateway, swagger support
	_ "github.com/grpc-ecosystem/grpc-gateway/codegenerator"
	_ "github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
	_ "github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger"
	_ "github.com/grpc-ecosystem/grpc-gateway/utilities"

	// template processor
	_ "github.com/tsg/gotpl"

	// static file packer
	_ "github.com/rakyll/statik"
)
