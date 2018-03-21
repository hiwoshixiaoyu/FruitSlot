GameTool=require"app.scenes.logic.CustomTool"
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function MainScene:onInterval()
 
        print("onInterval")
        nextScene = require("app.scenes.LoginScene").new()  
        print(nextScene)  
        local transition = display.wrapSceneWithTransition(nextScene, "fade", 1.5)  
            --替换,释放mainscence  
        display.replaceScene(transition)  

end



function MainScene:ctor()
    GameTool.preloadAni()
    GameTool.preloadOgg()
  
    self.bg = display.newColorLayer(cc.c4b(255, 255, 255,255))
    self.bg:addTo(self) 

    self.root = display.newLayer()
    self.root:addTo(self) 


    local callback = cc.CallFunc:create(function()    
        --
        local callback2 = cc.CallFunc:create(function()  
             print("callback2") 
             self:onInterval() 
        end) 
        self.root:setCascadeOpacityEnabled(true)
        local fadeOut =cc.FadeOut:create(1)
        local action3 = cc.Sequence:create(cc.DelayTime:create(1),fadeOut,callback2)
        self.root:runAction(action3)
    end)

 
    local move_left = cc.MoveTo:create(0.3, cc.p(display.cx-100,70)) 
    local big =  cc.ScaleBy:create(0.3,3)
    local small =  cc.ScaleTo:create(0.3,1)
    local xuanzuan= cc.RotateBy:create(0.3,360)
    local action = cc.Sequence:create(cc.DelayTime:create(1.5),move_left,big,xuanzuan,small)
    
    --background   
    self.bg = display.newSprite("Bg/logo.png")
    self.bg:center()
    self.bg:addTo(self.root)
    self.bg:setCascadeOpacityEnabled(true)

    self.author1 = display.newSprite("Bg/author1.png")
    self.author1:setPosition(0,0) 
    self.author1:addTo(self.root) 
    self.author1:setCascadeOpacityEnabled(true)
    self.author1:runAction(action)

    -- 移动放大 旋转
    local jump= cc.JumpTo:create(1.5,cc.p(display.cx+100,70),60,10)
    local action2 = cc.Sequence:create(cc.DelayTime:create(1.5),jump,callback)

    self.author2 = display.newSprite("Bg/author2.png")
    self.author2:setPosition(0,0)
    self.author2:addTo(self.root)
    self.author2:runAction(action2)

end




function MainScene:onEnter()
end

function MainScene:onExit()
        print("exit")
end

return MainScene