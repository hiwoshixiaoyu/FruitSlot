package main

import (
	//	"common"
	"encoding/json"
	"log"
)

func main() {
	type change struct {
		Start int
		End   int
	}

	type change_slice struct {
		Changes []change
	}

	//解json
	var msg change_slice
	/*
		str := `{"changes": [{"start":3,"end":5}, {"start":3,"end":6}]}`
		err := json.Unmarshal([]byte(str), &msg)
		if err != nil {
			log.Println("Can't decode json message", err)
		}
		log.Println(msg)

		for _, change := range msg.Changes {
			log.Println(change.Start)
			log.Println(change.Index)
		}
	*/
	//拼json
	msg.Changes = make([]change, 3)
	msg.Changes[0].Start = 1
	msg.Changes[0].End = 10
	msg.Changes[1].Start = 12
	msg.Changes[1].End = 102

	c, _ := json.Marshal(msg)
	log.Println(string(c))

}
