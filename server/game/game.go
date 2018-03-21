// game project game.go
package game

import (
	"common"
	"database/sql"
	"fmt"
	"log"

	"net/http"
	"strconv"
	"strings"

	_ "github.com/go-sql-driver/mysql"
)

//打印行号
//log.SetFlags(log.Lshortfile | log.LstdFlags)
func Game(w http.ResponseWriter, r *http.Request) {

	r.ParseForm()
	uuid := r.Form.Get("uuid")
	betStr := r.Form.Get("betArray")

	log.Println(uuid)
	var atemp []string
	atemp = strings.Split(betStr, "-")

	log.Println(atemp)
	if len(atemp) != 8 {
		log.Println("atemp-error")
		w.WriteHeader(403)
		fmt.Fprintf(w, "error")
		return
	}

	var betArray [8]int
	for index := 0; index < 8; index++ {
		var err error
		betArray[index], err = strconv.Atoi(atemp[index])
		if err != nil {
			w.WriteHeader(403)
			log.Println("Atoi error")
			return
		}
	}

	CheckLevel(uuid, betArray, w)
}

//检查权限
func CheckLevel(uuid string, betArray [8]int, w http.ResponseWriter) {

	betSum := 0
	for i := 0; i < 8; i++ {
		betSum += betArray[i]
	}

	db, err := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")
	if err != nil {
		log.Println("CheckLevel error")
		return
	}

	//查询是否有uuid玩家
	rows, err := db.Query("select gold From player Where uuid = ?", uuid)
	if err != nil {
		log.Println(err)
		defer db.Close()
		return
	}

	if rows.Next() {

		var TotalGold int
		if err := rows.Scan(&TotalGold); err != nil {
			log.Println(err)
		}

		winId, luckid, WinGold := gameService(betArray)

		//更新金币
		_, err2 := db.Query("update player set gold = gold + ? where uuid = ?", WinGold-betSum, uuid)
		if err2 != nil {
			log.Println(err2)
		}

		defer db.Close()
		log.Printf("%d-%d-%d-%d", winId, luckid, WinGold, TotalGold+WinGold-betSum)
		str2 := fmt.Sprintf("%d-%d-%d-%d", winId, luckid, WinGold, TotalGold+WinGold-betSum)

		//返回windId-luckId-WinGold-ownGold
		fmt.Fprintf(w, str2)
		return
	}
	fmt.Fprintf(w, "error")
	return
}

//逻辑处理
//winId,luckId, WinGold
func gameService(betArr [8]int) (int, int, int) {
	log.Println(betArr)
	s := make([]common.Fruit, 24)
	common.GetFruit(s)

	var WinGold, trainId int
	winId, luckid := common.GetFruitRand()
	if -1 == luckid || -1 == winId {
		log.Println("kind winId error")
	}

	if winId == 21 || winId == 9 { //幸运
		//特殊玩法
		switch luckid {
		case common.Fruit_BigThree:
			//大三元 7,15,19,
			WinGold = WinGold + betArr[4]*20
			WinGold = WinGold + betArr[7]*40
			WinGold = WinGold + betArr[5]*30
			luckid = 5
		case common.Fruit_SmallThree:
			//小三元
			//铃铛 芒果 橙子 * 3
			WinGold = WinGold + betArr[1]*3
			WinGold = WinGold + betArr[2]*3
			WinGold = WinGold + betArr[3]*3
			luckid = 2
		case common.Fruit_BigAll:
			//遍历betarry 0~8  0是luck
			for _, value := range s {
				if value.Zhuid == 0 {
					continue
				}
				WinGold += betArr[value.Zhuid-1] * value.Fenshu

			}
			luckid = 6
		case common.Fruit_SmallAll:
			//小满贯 2,5,8,11,14,17,20,23
			WinGold = WinGold + betArr[7]*50
			WinGold = WinGold + betArr[0]*3
			WinGold = WinGold + betArr[4]*3
			WinGold = WinGold + betArr[1]*3
			WinGold = WinGold + betArr[6]*3
			WinGold = WinGold + betArr[2]*3
			WinGold = WinGold + betArr[3]*3
			WinGold = WinGold + betArr[4]*3
			luckid = 4
		case common.Fruit_FourSmallApple:
			if betArr[0] > 0 {
				WinGold = (betArr[0] * 3) * 4
			}
			luckid = 3
		case common.Fruit_FourBigApple:
			if betArr[0] > 0 {
				WinGold = (betArr[0] * 5) * 4
			}
		case common.Fruit_Train: //客户端先判断luckId
			//todo
			trainId = common.GetTrainRand()
			winId = trainId

			var betNum int
			for i := 0; i <= 4; i++ {
				if trainId-i <= 0 {
					trainId = 24
				}
				betNum = s[trainId-i].Zhuid
				if betNum == 0 {
					continue
				}
				WinGold += s[trainId-i].Fenshu * betArr[betNum-1]
			}

		case common.Fruit_Over:
			WinGold = 0
		default:
			WinGold = 0
		}

	} else { //普通
		betNum := s[winId].Zhuid
		if betNum == 0 {
			log.Println("betNum error")
			betNum = 1
		}
		WinGold = betArr[betNum-1] * s[winId].Fenshu
		luckid = 0
	}

	return winId, luckid, WinGold
}
