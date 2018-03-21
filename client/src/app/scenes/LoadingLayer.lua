local LoadingLayer = class("LoadingLayer", function()
    return display.newColorLayer(cc.c4f(0,0,0,128))
end)


function LoadingLayer:ctor()
	print("LoadingLayer")	
end


function LoadingLayer:newLoading()
	print("loading...")
   -- self.backgroundLayer = display.newColorLayer(cc.c4f(0,0,0,128))
    self:setOpacity(0)  
    --网络异常,点击重试
    local loadingimg = ccui.ImageView:create("img/waiting.png",0)
    loadingimg:setPosition(display.cx,display.cy)
    local rotateBy = cc.RotateBy:create(0.5,360)
    loadingimg:runAction(cc.RepeatForever:create(rotateBy))
    loadingimg:addTo(self)
end


function LoadingLayer:distroyLoading()
    
end
function LoadingLayer:onEnter()
	 print("onEnter")	
end

function LoadingLayer:onExit()
      print("onExit")	  
end

return LoadingLayer