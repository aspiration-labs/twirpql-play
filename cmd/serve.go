/*
Copyright © 2020 aspiration.com

*/
package cmd

import (
	"context"
	"github.com/aspiration-labs/twirpql-play/proto/hello"
	"github.com/aspiration-labs/twirpql-play/proto/hello/twirpql"
	"net/http"

	"github.com/spf13/cobra"
)

// serveCmd represents the serve command
var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		run(cmd, args)
	},
}

func init() {
	rootCmd.AddCommand(serveCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// serveCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// serveCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

type service struct{}

func (s *service) Hello(ctx context.Context, req* hello.HelloReq) (*hello.HelloResp, error) {
	return &hello.HelloResp{Text: req.GetName()}, nil
}

func run(cmd *cobra.Command, args []string) {
	serviceImpl := &service{}
	http.Handle("/", hello.NewServiceServer(serviceImpl, nil))
	http.Handle("/query", twirpql.Handler(serviceImpl, nil))
	http.Handle("/play", twirpql.Playground("twirp", "/query"))
	http.ListenAndServe(":9090", nil)
}
