package main

import (
	"embed"
	"fmt"
	"io/fs"
	"net/http"

	utils "github.com/pthomison/golang-utils"
	"github.com/spf13/cobra"
)

type Form struct {
	FormString string
	FormNumber int32
	FormFloat  float32
	FormBool   bool
}

var (
	//go:embed web/*
	embeddedFiles embed.FS

	address string = "127.0.0.1:5050"

	rootCmd = &cobra.Command{
		Use:   "golang-webforms",
		Short: "golang-webforms",
		Run:   run,
	}
)

func main() {
	err := rootCmd.Execute()
	utils.Check(err)
}

func run(cmd *cobra.Command, args []string) {
	fmt.Println("--- golang-webforms ---")
	Server()
}

func Server() {
	web, err := fs.Sub(embeddedFiles, "web")
	utils.Check(err)

	http.Handle("/", http.FileServer(http.FS(web)))
	// http.HandleFunc("/subreddits", subreddits(c))
	http.HandleFunc("/form", Form)

	http.ListenAndServe(address, nil)
}

func Form(w http.ResponseWriter, r *http.Request) {

}
