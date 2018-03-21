
GameLogic = require"app.scenes.logic.GameLogic"

FruitBox = require"app.scenes.Box"

local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

ROUND_COUNT =24
BET_MAX  = 99

--startclick cancel click
function GameScene:dealTouch(sender, eventType)
  
    if 0 == eventType then
        --print("down",sender:getTag())
    elseif 2 == eventType then
        --print("up",sender:getTag())
        self:toBet(sender:getTag())
    end
end

function GameScene:dealbeishu()
    print(type(self.bei))
    local beishu = self.bei
    if  beishu== 10 then 
         print("10")
        self.bei = 1
        print(self)
        self.btnBei:loadTextures("btn/fruitx1_n.png", "btn/fruitx1_p.png", "",0)
        print(self.beiShu)

    elseif beishu== 5 then
          print("5")
            self.bei = 10
            self.btnBei:loadTextures("btn/fruitx10_n.png", "btn/fruitx10_p.png", "",0)
    elseif beishu == 1 then
        print("fuck")
        self.bei = 5
        print(self.beiShu)
        self.btnBei:loadTextures("btn/fruitx5_n.png", "btn/fruitx5_p.png", "",0)
    end 
           
end
--bet click
function GameScene:dealclickBet(sender, eventType)

    if eventType ~=  2 then
        return
    end

    if  "startBtn"== sender:getName() then
        --todo
            self:toStart()
    elseif "cancel" == sender:getName() then
        --todo
    elseif "beiShu" == sender:getName() then
            print("push")
            self:dealbeishu()
    elseif "1" == sender:getTag() then
        --todo
    end
end
--初始化成员变量
function GameScene:initm_()
    self.step = 0    --当前一轮进行阶段 0-开始押注 1-押注完播放动画中  2-转到luck播放第二阶段动画  3-一轮结束可下注押大小或不赌直接收钱 4-押注赌大小等待结果
    self.totalGold = GameLogic:Instance():getGold() --金币总数
    print(self.totalGold)
    self.username = GameLogic:Instance():getUserName()
    self.ownGold = 0   --除去押注和赢取的金币自己拥有的金币数量
    self.winGold = 0   -- 当前一轮压住赢的金币数量
    self.betGold = 0  --当前一轮押注金币
    self.borderPos = 0 --当前光标位置
    self.bei = 10 --倍数

    self.newRound = 0
    self.PressBet = 0  --连续押注的位置，0-是没有  1-8
    self.curWinId = 0  --本局中奖位置
    self.luckId = 0    --中goodluck之后得到的幸运结果 1-被吃掉了 2-小三元 3-小四喜 4-小满贯 5-大三元  6-大满贯  7-开火车
    self.trainId = 0   --中了开火车奖励，火车头开到的位置 0-23;
    self.pointNum = 0  --赌大小开出的点数 0-没有  1-14
    self.winFlag = 0   --赌大小有没有中
    self.betTime = 0
    self.betType = 0   --押注 1-赌大  2-赌小
end

--初始化可以点击的按钮
function GameScene:initUIClick()
    local temp = function (sender, eventType) self:dealclickBet(sender, eventType)end
    --startBtn
    self.startBtn =ccui.Button:create("img/go.png", "img/go_p.png", "", 0)
    self.startBtn:addTouchEventListener(temp)
    self.startBtn:setPosition(400,150)
    self.startBtn:addTo(self)
    self.startBtn:setName("startBtn")

    --cancelBtn
    self.cancelBtn = ccui.Button:create("img/QUXIAO.png", "img/QUXIAO_P.png", "", 0)
    self.cancelBtn:addTouchEventListener(function(send,eventType)  self:betCancel() end)
    self.cancelBtn:setPosition(100,150)
    self.cancelBtn:addTo(self)
    self.cancelBtn:setTag(2)

    --halfBtn de.png
    self.halfBtn = ccui.Button:create("img/de.png", "img/de_p.png", "", 0)
    --doubleBtn add_p
    self.doubleBtn = ccui.Button:create("img/add.png", "img/add_p.png", "", 0)
    --smallBtn  small.png
    self.smallBtn = ccui.Button:create("img/small.png", "img/small_p.png", "", 0)
    --bigBtn img/big.png
    self.bigBtn = ccui.Button:create("img/big.png", "img/big_p.png", "", 0)

    --soundBox -CheckBox
    self.soundBox = ccui.CheckBox:create("img/sound_mute.png","img/sound_on.png","","","",0)
    self.soundBox:addTouchEventListener(temp)
    self.soundBox:setPosition(50,265)
    self.soundBox:addTo(self)
    self.soundBox:setTag(3)


    
    --winNumLabel   num_red.png
    self.winNumLabel  = ccui.TextAtlas:create("23","img/num_red.png",39,58,'0')
    self.winNumLabel:addTouchEventListener(temp)
    self.winNumLabel:setPosition(132,217)
    self.winNumLabel:addTo(self)
    self.winNumLabel:setTag(4)

    --totalNumLabel num_red.png
    self.totalNumLabel  = ccui.TextAtlas:create("23","img/num_red.png",39,58,'0')
    self.totalNumLabel:addTouchEventListener(temp)
    self.totalNumLabel:setPosition(300,217)
    self.totalNumLabel:addTo(self)
    self.totalNumLabel:setTag(4)

    --*1 *5 *10倍数
    self.btnBei = ccui.Button:create("btn/fruitx1_n.png", "btn/fruitx1_p.png", "", 0)
    self.btnBei:addTouchEventListener(temp)
    self.btnBei:setPosition(300,150)
    self.btnBei:addTo(self)
    self.btnBei:setName("beiShu")

    --username
    self.author = display.newTTFLabel({text = "user:"..self.username,color = cc.c3b(255, 255,255),size = 16})

    self.author:setPosition(100,display.top-30)
    self.author:addTo(self)
end

function GameScene:initUI()


    self.bg = display.newSprite("img/slotmachine.png")  
        --设置透明度   
    self.bg:setPosition(235,350) 
    self.bg:addTo(self)  

    self.betArr = {0}
    --上一次点击
    self.prevBet = {0}
    --Fruit table
    self.arrayFruit = {}
    --点击Fruit的分数 table
    self.betLabels = {}

    for i = 1 , 8 , 1 do  
        local btn = ccui.Button:create(string.format("img/b%s.png",  i), string.format("img/b%sp.png",  i),"", 0) 
        btn:addTouchEventListener(function(sender, eventType) self:dealTouch(sender, eventType) end)
        btn:addTo(self)
        btn:setPosition(500-55*i,50)
        btn:setTag(i)  
        --self.betLabels[i] = display.newTTFLabel({text = "00", font = "fonts/Marker Felt"})
        self.betLabels[i] = ccui.TextAtlas:create("00","img/num_blue.png",15,24,'0')
        self.betLabels[i]:addTo(self)
        self.betLabels[i]:setPosition(500-65*i,110)
    end 

    for i = 1 , ROUND_COUNT , 1 do  
        self.arrayFruit[i] = FruitBox:new(0)
        self.arrayFruit[i]:setVisible(true)
        self.arrayFruit[i]:setPos(i)
        self.arrayFruit[i]:setVisible(false)
        --boxArr[i]->retain();
        self.arrayFruit[i]:addTo(self)
    end 


    self.box0 = FruitBox:new(1)
    self.box0:addTo(self)
    self.box0:setPos(1)
    self.box0:stop()
end

--构造

function GameScene:ctor()
     app.gameScene = self
    math.randomseed(os.time())

    self:initm_()
    self:initUI()
    self:initUIClick()
    
     print("self:",self)
    --initGame
    self.ownGold = self.totalGold
    self.winGold = 0

    for  i = 1,  8,1 do
        self.prevBet[i] = 0
    end

 

    self:clearBet()
    self:nextRound()

    self.imgMap = {}
    self.imgMap[1]= "img/eat"
    self.imgMap[2]= "img/xsy"
    self.imgMap[3]= "img/xsx"
    self.imgMap[4]= "img/xmg"
    self.imgMap[5]= "img/dsy"
    self.imgMap[6]= "img/dmg"
    self.imgMap[7]= "img/khc"
end

--下一局
function GameScene:nextRound()
    self.step = 0
    self.newRound = true
    self.PressBet = 0
end

function GameScene:showGoldNum()

    local flag = false
    for i = 0, 8, 1 do

        if self.betArr[i] ~= 0 then
            flag = true
            break
        end
    end

    self.betGold = 0
    for  i = 1, 8, 1 do 
         local betNum 
                 if flag then 
                      betNum =  self.betArr[i] 
                 else 
                      betNum =  self.prevBet[i]
                 end 
        self.betGold = self.betGold + self.betArr[i]
        str = ""

        if betNum >= 10 then
            str = tostring(betNum)
        else
            str = "0"..tostring(betNum)
        end
        self.betLabels[i]:setString(str)
    end

    self.ownGold = self.totalGold  - self.betGold
    self.totalNumLabel:setString(self.ownGold)
    self.winNumLabel:setString(self.winGold)
   -- CCUserDefault::sharedUserDefault()->setIntegerForKey("integer", totalGold);
   -- CCUserDefault::sharedUserDefault()->flush();
end

function GameScene:collectGold()

    self.winNumLabel:setString("00000000")
    self.totalGold =  self.totalGold +self.winGold
    self.winGold = 0

    self:nextRound()
    self:showGoldNum()
    self:clearResult()
end

function GameScene:toBet(pos)
    if self.step ~= 0 then   return end
    print("GameScene:toBet",self.betArr[pos])

   
    

    if self.ownGold == 0  then   return end
    if self.newRound then
        self:clearBet()
        self:clearResult()
        self.newRound = false
    end

    if self.PressBet == 0 then
        --CustomTool::playSoundEffect("sounds/s" + cocos2d::Value(pos).asString() + ".mp3");
        audio.playEffect("music/click.ogg", false)
    end
    print("self.beiShu:",self.bei)
    self.betArr[pos]  = self.betArr[pos]+(1*self.bei) 
    self:showGoldNum(1)
end


function GameScene:runBox()
    self.step = 1
    self.box0:run()
end


--important
function GameScene:bengin()  
    
    for  i = 1 ,8 , 1 do
        self.prevBet[i] = self.betArr[i]
        self.betArr[i] = 0
    end
    self:runBox()
    print("curWinId",self.curWinId)
    self.box0:setTargetPos(self.curWinId)
end

function GameScene:benginCallBack(winId,luckId,winGold,ownGold)
    
    print(winId,winGold,sumgold)
    self.winGold = winGold
    self.curWinId = winId 

    self.totalGold =  ownGold - winGold
    self.luckId = luckId
    --to do 算出luckId
    print("luckId:",luckId)

    self:bengin()
end

loadingImg = require"app.scenes.LoadingLayer"

function GameScene:benginCallBackFail()
    print("benginCallBackFail")
    self.step = 4
    self.loading = loadingImg:new()
    self.loading:addTo(self)
    self.loading:newLoading()
end

function GameScene:betAgain()
    local total = 0
    for i = 1, 8,1 do
        total = total +self.prevBet[i]
    end
    if self.totalGold < total then

        print("money has no enough")
        return
    end
    for  i = 1,  8,1 do
        self.betArr[i] = self.prevBet[i]
    end

    self:showGoldNum()

end
function GameScene:getWinId()
end
function GameScene:clearResult()
  --  CustomTool::stopAllEffects();
  --  CustomTool::playMusic("sounds/bg.mp3", true);
    if self.box1 then  self.box1:removeFromParent()   self.box1=nil          end
    if self.box2 then  self.box2:removeFromParent()      self.box2=nil       end
    if self.box3 then  self.box3:removeFromParent()     self.box3=nil        end
   
    if self.lightLeft  then self.lightLeft:removeFromParent()   self.lightLeft = nil end
    if self.lightRight then self.lightRight:removeFromParent()   self.lightRight = nil end

    for  i = 1 , ROUND_COUNT,1 do
       self.arrayFruit[i]:setVisible(false)
    end

end

function GameScene:toStart()
    --CustomTool::playSoundEffect("sounds/s1.mp3");
    if  self.step == 3 then --gold to right
        self:collectGold()
    elseif self.step == 0 then
        
        self:clearResult()

        if self.betGold <= 0 then

             self:betAgain()
        end
       
        if self.betGold > 0 then
            --发送请求，请求成功后走下面逻辑

            self.step = 1
            GameLogic:Instance():betPost(self.betArr)
            --self:bengin()
            --self:getWinId()
           -- CustomTool::playSoundEffect("sounds/TURN_START.mp3");
        end
    elseif self.step == 4 then
        self:removeChild(self.loading)
        self.step = 1
            GameLogic:Instance():betPost(self.betArr)
    end

end


--清理bet 和win gold
function GameScene:clearBet()

   for  i = 1 , 8, 1 do
         self.betArr[i] = 0
   end

    self.winGold = 0
    self:showGoldNum()
end
function GameScene:betCancel()

    if self.step ~= 0 then 
         return
    end
    --  CustomTool::playSoundEffect("sounds/s1.mp3");
    self:clearBet()
    for  i = 1,8,1 do
      self.prevBet[i] = 0
    end
    self:showGoldNum()
end
function GameScene:onEnter()
end

function GameScene:getResult()
    print("getResult",self)

    if self.step == 1 then
        if self.curWinId == 9 or self.curWinId == 21 then
            print("---luck---")
            self.step = 2
            self.box0:starFast()
           -- playSoundEffect(curWinId);
        else
            if self.winGold > 0 then
                --playSoundEffect(curWinId);
            else
               --CustomTool::playSoundEffect("sounds/chidiao.mp3");
            end
            self:performWithDelay(function (t)  self:waitLater(t) end, 2)

            self.box0:stop()
            self:showGoldNum()
        end
    elseif self.step == 2 then
        self:performWithDelay(function (t)  self:waitLater(t) end, 3)
        self:showGoldNum()
    end


end
function GameScene:playResult()

    print("playResult")
    print("self.luckId:",self.luckId)
    --result
    if self.luckId == 1 then
        self.sprite = display.newSprite(self.imgMap[self.luckId].. ".png")
        self.sprite:center()
        self.sprite:addTo(self)
        --CustomTool::playSoundEffect("sounds/chidiao.mp3");
    end

        self.box0:setVisible(false)
        self.sprite2 = display.newSprite()

        --local frames = display.newFrames("img/light%d.png", 0, 1)  
    
        --local animation = display.newAnimation(frames, 0.5)  
        --local animate = cc.Animate:create(animation)

        --self.sprite2:runAction(cc.RepeatForever:create(animate))

         if self.luckId == 2 then  --小三元
                self.arrayFruit[11]:setVisible(true)
                self.arrayFruit[17]:setVisible(true)
                self.arrayFruit[23]:setVisible(true)
                audio.playEffect("music/luck_xsy.ogg", false)
         elseif self.luckId == 3 then --小四喜
                self.arrayFruit[4]:setVisible(true)
                self.arrayFruit[10]:setVisible(true)
                self.arrayFruit[16]:setVisible(true)
                self.arrayFruit[22]:setVisible(true)
                audio.playEffect("music/luck_dsx.ogg", false)
         elseif self.luckId == 4 then--小满贯
                self.arrayFruit[2]:setVisible(true)
                self.arrayFruit[5]:setVisible(true)
                self.arrayFruit[8]:setVisible(true)
                self.arrayFruit[11]:setVisible(true)
                self.arrayFruit[14]:setVisible(true)
                self.arrayFruit[17]:setVisible(true)
                self.arrayFruit[20]:setVisible(true)
                self.arrayFruit[23]:setVisible(true)
                audio.playEffect("music/luck_xmg.ogg", false)
        elseif self.luckId == 5 then --大三元
                self.arrayFruit[7]:setVisible(true)
                self.arrayFruit[15]:setVisible(true)
                self.arrayFruit[19]:setVisible(true)
                audio.playEffect("music/luck_dsy.ogg", false)
        elseif self.luckId == 6 then  --big all
              for  i = 1,24,1 do
                 self.arrayFruit[i]:setVisible(true)
              end
              self:lightUp()
                 audio.playEffect("music/luck_dmg.ogg", false)
        elseif self.luckId == 7 then   --train
            --todo
              self:startTrain()
              sumgold= 100
        end
    


    if self.luckId ~= 7 then
        self:getResult()
        if self.luckId ~= 1 then 
           -- CustomTool::playMusic("sounds/w9.mp3",true);
        end
    end      

end


function GameScene:lightUp()
    print("llll")
    self.lightLeft = display.newSprite()
    self.lightRight = display.newSprite()

    local action = cc.Animate:create(display.getAnimationCache("haha")) 
    local action1 = cc.Animate:create(display.getAnimationCache("haha"))  
    self.lightLeft:setPosition(15,500)
    self.lightRight:setPosition(450,500)

	self.lightLeft:addTo(self)
	self.lightRight:addTo(self)
    self.lightLeft:runAction(action) 
    self.lightRight:runAction(action1) 

end


function GameScene:startTrain()
    local pos = self.box0:getPos()
    self.box1 = FruitBox:new(1)
    self.box2 = FruitBox:new(2)
    self.box3 = FruitBox:new(3)
    self.box1:setPos(pos)
    self.box2:setPos(pos)
    self.box3:setPos(pos)
    self.box1:addTo(self)
    self.box2:addTo(self)
    self.box3:addTo(self)

    self.box0:run(true)
    self.box0:setTargetPos(self.trainId)

    --box0->run(CC_CALLBACK_0(GameScene::followFirstTrain, this))
   -- self.box0:setTargetPos(trainId)
end

function GameScene:followFirstTrain()
    if self.box1:getPos() ~= self.box0:getPos() then
        self.box1:setPos(self.box0:getPos() - 1)
    end
    if self.box2:getPos() ~= self.box1:getPos() then
        self.box2:setPos(self.box1:getPos() - 1)
    end
    if self.box3:getPos() ~= self.box2:getPos() then
        self.box3:setPos(self.box2:getPos() - 1)
    end
end

function GameScene:waitLater(t)
    print("waitLater")
    if self.winGold > 0 then
        self.step = 3
    else
        self:nextRound()
    end
end





function GameScene:onExit()
        
end

return GameScene