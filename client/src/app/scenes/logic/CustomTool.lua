local CustomTool = {}


function CustomTool:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self  
    return o  
end  

function CustomTool:Instance()  
    if self.instance == nil then  
        self.instance = self:new()  
    end  
    return self.instance  
end 


function CustomTool:init()

end


function CustomTool:Wifistate()
	print("WiFi status:" .. tostring(network.isLocalWiFiAvailable()))
    print("3G status:" .. tostring(network.isInternetConnectionAvailable()))
    --分析域名是否可以解析
    print("HomeName:" .. tostring(network.isHostNameReachable("cn.cocos2d-x.org")))


     local netStatus = network.getInternetConnectionStatus()
    if netStatus == cc.kCCNetworkStatusNotReachable then
        print("kCCNetworkStatusNotReachable")
    elseif netStatus == cc.kCCNetworkStatusReachableViaWiFi then
        print("kCCNetworkStatusReachableViaWiFi")
    elseif netStatus == cc.kCCNetworkStatusReachableViaWAN then
        print("kCCNetworkStatusReachableViaWAN")
    else
        print("Error")
    end

end




function CustomTool.preloadBackgroundMusic()
end

function CustomTool.preloadOgg()
    local callback = function() print("load")end
    local callback2 = function() audio.playEffect("music/start.ogg", false) end

    
    audio.loadFile("music/start.ogg",callback2)  
    audio.loadFile("music/click.ogg",callback)
    audio.loadFile("music/collectGold.ogg",callback)
    audio.loadFile("music/wheel03.ogg",callback)

   -- audio.loadFile("music/luck_dmg.ogg",callback)
    --audio.loadFile("music/luck_xmg.ogg",callback)
    --audio.loadFile("music/luck_xsy.ogg",callback)
    --audio.loadFile("music/luck_dsy.ogg",callback)
    --audio.loadFile("music/luck_dsx.ogg",callback)

  
end



function CustomTool.preloadAni()
        local animate = cc.Animation:create()  
            animate:addSpriteFrameWithFile("img/light0.png")  
            animate:addSpriteFrameWithFile("img/light1.png")  
            animate:setLoops(-1)  
            animate: setDelayPerUnit(0.5)  
  
    display.setAnimationCache("haha",animate)  
        
end

function CustomTool.preloadEffect( filename)
end
function  CustomTool.pauseEffect(soundId)
end
function CustomTool.resumeEffect( nSoundId)
end
function CustomTool.stopAllSound()
end
function CustomTool.playSoundEffect()
end
function CustomTool.stopEffect(nSoundId)
end
function CustomTool.stopAllEffects()
end
return CustomTool