local ErrorLayer= class("ErrorLayer", function()
    return display.newColorLayer(cc.c4f(0,0,0,128))
end)


function ErrorLayer:ctor()
	print("ErrorLayer.")	
end


function ErrorLayer:newLoading()
	print("loading...")
   -- self.backgroundLayer = display.newColorLayer(cc.c4f(0,0,0,128))
    self:setOpacity(0)  
    --网络异常,点击重试
    local loadingimg = ccui.ImageView:create("img/error.png",0)
    loadingimg:setPosition(display.cx,display.cy)
    local rotateBy = cc.RotateBy:create(0.5,360)
    loadingimg:runAction(cc.RepeatForever:create(rotateBy))
    loadingimg:addTo(self)
end


function ErrorLayer:distroyLoading()
    
end
function ErrorLayer:onEnter()
	 print("onEnter")	
end

function ErrorLayer:onExit()
      print("onExit")	  
end

return ErrorLayer