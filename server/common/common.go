// common project common.go
package common

import (
	"database/sql"
	"encoding/json"
	"log"
	"math/rand"
	"sync"
	"time"
)

type Fruit struct {
	Fenshu int
	Zhuid  int
}

var slice []Fruit
var Ip string

type State int

const (
	change  State = iota // value --> 0
	Stopped              // value --> 1
	Finish               // value --> 2
)

const (
	Fruit_SmallThree     int = 22 //-->0 "小三元",
	Fruit_BigThree           = 23 //"大三元"
	Fruit_FourSmallApple     = 24 // "小四喜",
	Fruit_FourBigApple       = 25 //"大四喜"
	Fruit_SmallAll           = 26 // "小满贯",
	Fruit_BigAll             = 27 //"大满贯"
	Fruit_Train              = 28 //"开火车"
	Fruit_Over               = 29 //"over
	Fruit_GameOver           = 30 //"over
)

type GL struct {
	Id    int
	Name  string
	Start int
	End   int
}

type GL_slice struct {
	FruitGL []GL
}

var gai []GL
var mutex *sync.Mutex

func SetFruit(s []Fruit) {
	//mutex.Lock()
	copy(slice, s)
	//mutex.Unlock()
}

func GetFruit(s []Fruit) {
	//mutex.Lock()
	copy(s, slice)
	//mutex.Unlock()
}

func Init() {

	mutex = new(sync.Mutex)
	slice = make([]Fruit, 24)
	slice = []Fruit{
		Fruit{15, 4},  //大铃铛 0
		Fruit{50, 8},  //小bar1
		Fruit{120, 8}, //大bar2
		Fruit{5, 1},   //大苹果3
		Fruit{3, 1},   //小苹果4
		Fruit{10, 3},  //大芒果5
		Fruit{20, 5},  //大西瓜6
		Fruit{3, 5},   //小西瓜7
		Fruit{0, 0},   //LUCK8
		Fruit{5, 1},   //大苹果9
		Fruit{3, 2},   //小橘子10
		Fruit{10, 2},  //大橘子11
		Fruit{15, 4},  //大铃铛12
		Fruit{3, 7},   //小7713
		Fruit{40, 7},  //大7714
		Fruit{5, 1},   //大苹果15
		Fruit{3, 3},   //小芒果16
		Fruit{10, 3},  //大芒果17
		Fruit{30, 6},  //大双星18
		Fruit{3, 6},   //小双星19
		Fruit{0, 0},   //大good20
		Fruit{5, 1},   //大苹果21
		Fruit{3, 4},   //小铃铛22
		Fruit{10, 2},  //大橘子23
	}
	Ip = "127.0.0.1:8088"
	log.Println(Ip)
	initGaiLv()
}

//var isGL bool
func initGaiLv() {
	gai = make([]GL, 31)

	db, _ := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")

	rows, err := db.Query("select * From fruitslot")
	if err != nil {
		log.Println(err)
		defer db.Close()
		return
	}
	var name string
	var No, id, start, end, gailv int
	for rows.Next() {

		if err := rows.Scan(&No, &name, &id, &start, &end, &gailv); err != nil {
			log.Println(err)
		}
		gai[No-1].Id = id
		gai[No-1].Name = name
		gai[No-1].Start = start
		gai[No-1].End = end

	}
	log.Println(gai)
}

//解析GL{1,"xxx",1,10},json,校验参数
//生成json返回参数

func ParseJson(byteStr []byte) bool {
	var msg GL_slice

	//str := `{"fruitGL": [{"Id":1,"Name":"aaa","start":3,"end":5}, {"Id":1,"Name":"aaa","start":3,"end":6}]}`
	//err := json.Unmarshal([]byte(str), &msg)
	err := json.Unmarshal(byteStr, &msg)
	if err != nil {
		log.Println("Can't decode json message", err)
		return false
	}

	log.Println(msg)
	gtemp := make([]GL, 31)
	if len(msg.FruitGL) != 31 {
		log.Println("html error")
		return false
	}
	var sum int
	for index, change := range msg.FruitGL {
		if index > 31 {
			return false
		}
		if change.Start > change.End {
			return false
		}

		if index > 1 && index < 31 {
			if change.Start >= msg.FruitGL[index-1].End {

			}
		}
		gtemp[index].Start = change.Start
		gtemp[index].End = change.End
		//log.Printf("%s--%d~%d", gtemp[index].Name, gtemp[index].Start, gtemp[index].End)
		sum += change.End - change.Start + 1
	}

	if sum != 1000 {
		return false
	}

	//校验数据 start1<end1<start2 sum =1000数据正确

	//保存数据库
	/*db, _ := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/test?charset=utf8")
	_, err2 := db.Query("update player set gold = gold + ? where uuid = ?", WinGold-betSum, uuid)
	if err2 != nil {
		log.Println(err2)
		return false
	}*/
	//setGL

	return true
}

func MakeJson() []byte {
	c, _ := json.Marshal(gai)
	return c
}

func setGL(gl []GL) {
	mutex.Lock()
	copy(gai, gl)
	mutex.Unlock()
}

func getGL(gl []GL) {
	mutex.Lock()
	copy(gl, gai)
	mutex.Unlock()
}

//return winid luckid
func GetFruitRand() (int, int) {

	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	winId := rnd.Intn(1000)

	gl := make([]GL, 31)
	getGL(gl)
	for index, value := range gl {
		if winId <= value.End && winId >= value.Start {
			log.Printf("winId:%d-luckId:%d", value.Id, value)
			return value.Id, index
		}
	}

	return -1, -1
}

func GetTrainRand() int {
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	trainId := rnd.Intn(23)
	if trainId == 20 || trainId == 8 {
		trainId = trainId - 1
	}
	return trainId
}
