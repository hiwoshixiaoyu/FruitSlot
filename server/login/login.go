// login project login.go
package login

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func Login(w http.ResponseWriter, r *http.Request) {

	r.ParseForm()
	username := r.Form.Get("username")
	pwd := r.Form.Get("pwd")
	method := r.Form.Get("method")

	log.Println("login:", username, pwd, method)

	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")
	if err != nil {
		log.Println(err)
		w.WriteHeader(404)
		fmt.Fprintf(w, "fail open mysql")
		defer db.Close()
		return
	}

	//先用username匹配
	rows, err := db.Query("select * From player Where username=? and pwd=?", username, pwd)
	if err != nil {
		log.Println(err)
		w.WriteHeader(404)
		fmt.Fprintf(w, "login error")
		defer db.Close()
		return
	}

	if rows.Next() {
		var username, pwd, uuid string
		var gold, zuanshi int
		rows.Scan(&username, &pwd, &uuid, &gold, &zuanshi)
		w.WriteHeader(200)

		response := fmt.Sprintf("%s,%d,%d", username, gold, zuanshi)
		fmt.Fprintf(w, response)
		log.Println(response)
		defer db.Close()
		return
	} else if method == "youke" {
		_, err = db.Exec("insert into player(username,uuid, pwd,gold,zuanshi) values(?,?,?,?,?)", username, "uuid", pwd, 1000, 10)
		if err != nil {
			w.WriteHeader(404)
			fmt.Fprintf(w, "has Exec insert error")
			log.Println(err)
			defer db.Close()
			return
		}
		response := fmt.Sprintf("%s,%d,%d", username, 1000, 10)
		log.Println(response)
		defer db.Close()
	}

	w.WriteHeader(404)
	fmt.Fprintf(w, "error")
	defer db.Close()
}
