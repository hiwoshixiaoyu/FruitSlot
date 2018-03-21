// main project main.go
package main

import (
	"admin"
	"common"
	"game"
	"login"
	"net/http"
	"regist"
)

func main() {
	common.Init()
	server := http.Server{
		Addr: common.Ip,
	}

	http.HandleFunc("/login", login.Login)
	http.HandleFunc("/regist", regist.Regist)
	http.HandleFunc("/game", game.Game)

	http.Handle("/", http.FileServer(http.Dir("./../html")))
	http.HandleFunc("/admin", admin.Admin)
	//管理员专用网址
	//todo
	server.ListenAndServe()
}
