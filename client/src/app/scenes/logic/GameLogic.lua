errorMsg = require"app.scenes.ErrorLayer"


local GameLogic = {}
ConfigIp = "http://127.0.0.1"
ConfigPort =":8088"
ConfigIpPort = ConfigIp..ConfigPort
Config_Login = ConfigIpPort.."/login"
Config_Game =  ConfigIpPort.."/game"

function GameLogic:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self  
    return o  
end  

function GameLogic:Instance()  
    if self.instance == nil then  
        print("new dan li")
        self.instance = self:new()  
    end  
    print("Instance:",self.instance)
    return self.instance  
end 

function GameLogic:initUserData()
    self.username = "~!@#$%^"
    self.gold = 300
    self.zuanshi = 10
    self.level = 1
    self.postArray = ""
end


function GameLogic:setUUID(uuid)  
    self.uuid = uuid 
end  


function GameLogic:getUUID()  
    return self.uuid 
end  

function GameLogic:setUserName(username)  
    self.username = username 
end  

function GameLogic:getUserName()   
    return self.username
end  


function GameLogic:setlevel(level)   
        self.level = level
end 

function GameLogic:getlevel()   
    return self.level
end 

function GameLogic:setGold(gold) 
    
     print("http-gold:",gold)
     self.gold = gold
end 

function GameLogic:setZuanShi(zuanShi)   
     self.zuanshi = zuanShi
end 

function GameLogic:getGold()   
    print("return:",self.gold )
    return self.gold
end 

function GameLogic:setZuanShi(zuanShi)   
    return  self.zuanshi
end 



function GameLogic:onRequestCallback(event)

     --luck错误需要  selfid置回0
     local request = event.request

        if event.name == "completed" then
            print("completed")
             print(request:getResponseHeadersString())
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                print(code)
                app.gameScene:benginCallBackFail()
                return
            end

            local response = request:getResponseString()

            print("response:",response)
            
            local resultStrList = {}
            local reps = "-"
           string.gsub(response,'[^'..reps..']+',function (w)
                            table.insert(resultStrList,w)
                        end)
            --response
    
            print("winGold:",resultStrList[1])
            print("luckid:",resultStrList[2])
            print("SumGold:",resultStrList[3])
            print("ownGold",resultStrList[4])
            app.gameScene:benginCallBack(tonumber(resultStrList[1]),
                                         tonumber(resultStrList[2]),
                                         tonumber(resultStrList[3]),
                                         tonumber(resultStrList[4]))
        elseif event.name == "progress" then
            print("progress" .. event.dltotal)
        else
            -- 请求失败，显示错误代码和错误消息
            print(event.name)
            print(request:getErrorCode(), request:getErrorMessage())
            --弹个popup 网络超时
             app.gameScene:benginCallBackFail()
            return
        end

end

function GameLogic:betPost(betArr)

    self.postArray = ""
    for i = 1 , 8 , 1 do
        if 8 == i then
            self.postArray = self.postArray..string.format("%d",  betArr[i])
            break
        end
        self.postArray = self.postArray..string.format("%d-",  betArr[i])
    end

    local request = network.createHTTPRequest(function(event) 
                                                self:onRequestCallback(event) 
                                                end, Config_Game, "POST")
    request:addPOSTValue("uuid", "uuid")
    request:addPOSTValue("betArray", self.postArray)
    print(self.postArray)
    request:start()   
end


return GameLogic