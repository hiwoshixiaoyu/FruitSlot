loadingImg = require"app.scenes.LoadingLayer"
GameLogic = require"app.scenes.logic.GameLogic"

local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

function LoginScene:LoginWeChat()
    print("wechat")
end

function LoginScene:LoginByYouke()
    print("youke")
    local request = network.createHTTPRequest(function(event) 
                                                self:onRequestCallback(event) 
                                                end, 
                                                Config_Login, "POST")
    request:addPOSTValue("method","youke")
    request:addPOSTValue("username", device.getOpenUDID())
    request:addPOSTValue("pwd", "123456")
    request:start()

    self.loading = loadingImg:new()
    self.loading:addTo(self)
    self.loading:newLoading()
end

function LoginScene:initUI()

    local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            if ref:getName()=="weichat" then
                self:LoginWeChat()
            elseif ref:getName()=="youke" then
                self:LoginByYouke()
            end
        end
    end
    
    --游客登录
    ccui.Button:create("Login/visitor_button_0.png", "Login/visitor_button_1.png", "Login/visitor_button_2.png",0)
        :setPosition(display.cx,display.cy-200)
        :setName("youke")
        :addTo(self)
        :addTouchEventListener(btcallback)

    --微信登陆
    ccui.Button:create("Login/thrid_part_wx_0.png", "Login/thrid_part_wx_1.png", "Login/thrid_part_wx_2.png",0)
        :setPosition(display.cx,display.cy-280)
        :setName("weichat")
        :addTo(self)
        :addTouchEventListener(btcallback)

end


function LoginScene:ctor()
	print("LoginScene")
    self:initUI()
end




function LoginScene:onEnter()
end

function LoginScene:onExit()
        
end

function LoginScene:onRequestCallback(event)


     local request = event.request
        if event.name == "completed" then
            print("completed")
             print(request:getResponseHeadersString())
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                print(code)
                return
            end
            if self.loading then
                self:removeChild(self.loading)
            end
            
            local resultStrList = {}
            local reps = ","
            local response = request:getResponseString()
           string.gsub(response,'[^'..reps..']+',function (w)
                            table.insert(resultStrList,w)
                        end)
            --response

            
            GameLogic:Instance():initUserData()
            GameLogic:Instance():setUserName(resultStrList[1])
            GameLogic:Instance():setGold(resultStrList[2])
            GameLogic:Instance():setZuanShi(resultStrList[3])

            self:ReplaceScene()
        elseif event.name == "progress" then
            print("progress" .. event.dltotal)
        else
            -- 请求失败，显示错误代码和错误消息
            print(event.name)
            print(request:getErrorCode(), request:getErrorMessage())
            if self.loading  then
                self:removeChild(self.loading)
            end

            return
        end

end
function LoginScene:ReplaceScene()
    print("ReplaceScene")
    nextScene2 = require("app.scenes.GameScene").new()  
    print(nextScene)  
    local transition = display.wrapSceneWithTransition(nextScene2, "fade", 1.5)  
        --替换,释放mainscence  
    display.replaceScene(transition)  
 
end
return LoginScene