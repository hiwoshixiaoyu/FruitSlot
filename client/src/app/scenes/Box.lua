

local Box = class("Box", function()
    return display.newSprite()
end)


local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function Box:ctor(kind,i)

  -- int
  self.step = 0
  self.startPos= 0
  self.targetPos= 0
  -- float
  self.runProcess= 0
  self.process= 0
  self.speed= 0
  self.addSpeed= 0
  --回调函数
  self.callbackFun= 0
  self.starNum= 0
  self.Isrunning= 0
  self.pos= 0


  	--添加图片
  self:setTexture(string.format("img/box%s.png",i))
  self:setScale(0.85)
end


function Box:setTargetPos(target)
  self.targetPos = target
  while (self.targetPos - self.pos) < 48 do
     self.targetPos = self.targetPos+24
  end
end

function Box:starFast()
  self.starNum = 0
  
  if self.m_starHandler then
     self:stopAction(self.m_starHandler)
  end
  self.m_starFastHandler = self:schedule(function (t) self:starFastHandler() end, 0.1)
end

function Box:stop()

  self.step = 4
  self.starNum = 0
  self.running = false

  if self.m_runHandler then
     self:stopAction(self.m_runHandler)
  end
  print("Box:schedule",self)
  self.m_starHandler = self:schedule(function (t)  self:starHandler(t) end, 0.5)
end 

--开火车需要一个callback
function Box:run(needTrain)
  print("needTrain:",needTrain)
  self.startPos = self.pos
  self.process = 0
  self.speed = 1
  self.addSpeed = 0
  self.targetPos = -1
  self.step = 0
  self:setVisible(true)


  if self.m_starHandler then
    self:stopAction(self.m_starHandler)
  end
 
  self.m_runHandler = self:schedule(function () self:runHandler(needTrain) end, 0.03)
  audio.playEffect("music/wheel03.ogg", false)

end

--旋转
function Box:runHandler(needTrain)

 
    --print("Box:runHandler")
    if self.step == 0
    then
         self.process = self.process +0.33
      if self.process >= 5 then
         self.step = 1
      end
      --
       print("aaa",self.process)
    
         local process,_ = math.modf(self.process,1)
      if self.pos ~= (self.startPos + process) then
          print("play..sound",process)
         -- audio.playEffect(string.format("music/s%s.ogg",process), false)
      end

    elseif self.step == 1 then
           self.process = self.process+self.speed
            if self.process >24 and self.targetPos > -1 then
              self.startPos = self.pos
              self.process = 0
              self.speed = 1
              self.runProcess = self.targetPos - self.pos
              --加速度
              self.addSpeed = - self.speed * self.speed * 0.5 / self.runProcess
              self.step = 2
            end
    elseif self.step == 2 then
          local prev_speed = self.speed
          self.speed = self.speed + self.addSpeed
          self.process = (self.speed + prev_speed) * 0.5+self.process
          if  self.process >= self.runProcess or self.speed < 0.01 then
            self.speed = 0
            self.process = self.runProcess

              if self.m_runHandler then
                  self:stopAction(self.m_runHandler)
              end
            self:runStop()
             --audio.playEffect("music/damanguan.ogg", false)
          end
    end


    local p,_ = math.modf(self.startPos + self.process,24) --% 24

    if self.pos ~= p and self.step > 0 then
    --CustomTool::playSoundEffect("sounds/run.ogg");// +cocos2d::Value(((int)process) % 10).asString() + ".ogg");
      -- audio.playEffect("music/run.ogg", false)
    end
    self:setPos(p)
    if needTrain then
        print("开火车")
      app.gameScene:followFirstTrain()
    end

end

function Box:runStop()
    app.gameScene:getResult()
end


function Box:starHandler(t)
   if self.running then
      self:setVisible(true)
      return
  end
  self.starNum =  self.starNum + 1
  self:setVisible(self.starNum % 2 == 0)
end

function Box:starFastHandler()
  self.starNum = self.starNum +1
  self:setVisible(self.starNum % 2 == 1)
  if  self.starNum > 20 then
     self:setVisible(true)
     if self.m_starFastHandler then
       --todo
       self:stopAction(self.m_starFastHandler)
     end
     app.gameScene:playResult()
  end
end

function Box:setPos(pos)
 --情况还是不太懂
  if pos < 0 
  then
    pos  = pos + ROUND_COUNT
  elseif pos >= ROUND_COUNT 
  then
    pos = pos % ROUND_COUNT
  end
  self.pos = pos
  v = {x =0 , y = 0}
  if pos < 7 
  then
    v.x = 63+ pos * 57
    v.y = 660
  elseif pos < 13 
  then
    v.x = 409
    v.y = 660 - (pos - 6) * 57
  elseif pos < 19 
  then
    v.x = 409 - (pos - 12) * 57
    v.y = 318
  else
    v.x = 63
    v.y = 318 + (pos - 18) * 57
  end
  --print(v.x,v.y)
  self:setPosition(v.x,v.y);
end

function Box:getPos()
  return self.pos
end


function Box:onEnter()
   print("Box----------onEnter")
end

function Box:onExit()
end

return Box
