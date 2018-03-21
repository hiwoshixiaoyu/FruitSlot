// regist project regist.go
package regist

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func Regist(w http.ResponseWriter, r *http.Request) {
	log.Println(r.Method)
	r.ParseForm()
	username := r.Form.Get("username")
	pwd := r.Form.Get("pwd")
	log.Println("username:%s,%d:pwd", username, pwd)

	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")
	if err != nil {
		fmt.Println(err)
		w.WriteHeader(404)
		fmt.Fprintf(w, "fail open mysql")
		defer db.Close()
		return
	}

	//注册前先用username匹配
	rows, err := db.Query("select username From player Where username = ?", username)
	if err != nil {
		fmt.Println(err)
		w.WriteHeader(404)
		fmt.Fprintf(w, "has Query error")
		defer db.Close()
		return
	}

	if rows.Next() {
		var username, pwd string
		rows.Scan(&username, &pwd)
		w.WriteHeader(403)
		fmt.Fprintf(w, "has regist")
		defer db.Close()
		return
	}

	//注册函数
	_, err = db.Exec("insert into player(username,uuid, pwd,gold,zuanshi) values(?,?,?,?,?)", username, "uuid", pwd, 1000, 10)
	if err != nil {
		w.WriteHeader(404)
		fmt.Fprintf(w, "has Exec insert error")
		log.Println(err)
		defer db.Close()
		return
	}

	fmt.Fprintf(w, "success")
	defer db.Close()
}
