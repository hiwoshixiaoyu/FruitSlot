// admin project admin.go
package admin

import (
	"common"
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func Admin(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		log.Println(common.MakeJson())

		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Write(common.MakeJson())
	} else if r.Method == "POST" {

		//获取cookies验证
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Origin", "*")

		c1, err := r.Cookie("uuid")
		log.Printf("%s", c1.Value)
		if err != nil {
			fmt.Fprintln(w, "Cannot get cookie")
			return
		}
		if false == Access(c1.Value) {
			fmt.Fprintf(w, "error")
			return
		}
		result, _ := ioutil.ReadAll(r.Body)
		common.ParseJson(result)

		w.WriteHeader(200)
		fmt.Fprintf(w, `{"sites": [{ "a":"a" }]}`)
	}

}

func Access(uuid string) bool {

	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")
	if err != nil {
		log.Println("CheckLevel error")
		return false
	}
	//查询是否有uuid玩家
	rows, err := db.Query("select * From gm Where uuid = ?", uuid)
	if err != nil {
		log.Println(err)
		defer db.Close()
		return false
	}

	if rows.Next() {
		log.Println("admin post")
		return true
	}
	log.Println("error")
	return false
}
