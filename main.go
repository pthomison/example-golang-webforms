package main

import (
	"embed"
	"fmt"
	"io/fs"
	"net/http"
	"strconv"

	utils "github.com/pthomison/golang-utils"
	"github.com/spf13/cobra"
)

type Form struct {
	FormString string
	FormNumber int
	FormFloat  float64
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
	http.HandleFunc("/form", FormFunc)

	http.ListenAndServe(address, nil)
}

func FormFunc(w http.ResponseWriter, r *http.Request) {

	form := &Form{}
	r.ParseForm()

	form.FormString = r.FormValue("FormString")

	fn_str := r.FormValue("FormNumber")
	if fn_str != "" {
		fn, err := strconv.Atoi(fn_str)
		utils.Check(err)
		form.FormNumber = fn
	}

	ff_str := r.FormValue("FormFloat")
	if ff_str != "" {
		ff, err := strconv.ParseFloat(ff_str, 64)
		utils.Check(err)
		form.FormFloat = ff
	}

	fb_str := r.FormValue("FormBool")
	fmt.Println(fb_str)
	if fb_str == "on" {
		form.FormBool = true
	}

	fmt.Printf("%+v\n", form)
	fmt.Printf("%+v\n", r.Form)

	http.Redirect(w, r, "/", http.StatusFound)
}
