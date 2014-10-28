--[[

-----------------------------------------------------------------------------------------
      ___           ___                       ___                                   ___           ___     
     /  /\         /  /\          ___        /  /\          ___       ___          /  /\         /__/\    
    /  /::\       /  /::\        /  /\      /  /::\        /  /\     /  /\        /  /::\        \  \:\   
   /  /:/\:\     /  /:/\:\      /  /:/     /  /:/\:\      /  /:/    /  /:/       /  /:/\:\        \  \:\  
  /  /:/~/:/    /  /:/  \:\    /  /:/     /  /:/~/::\    /  /:/    /__/::\      /  /:/  \:\   _____\__\:\ 
 /__/:/ /:/___ /__/:/ \__\:\  /  /::\    /__/:/ /:/\:\  /  /::\    \__\/\:\__  /__/:/ \__\:\ /__/::::::::\
 \  \:\/:::::/ \  \:\ /  /:/ /__/:/\:\   \  \:\/:/__\/ /__/:/\:\      \  \:\/\ \  \:\ /  /:/ \  \:\~~\~~\/
  \  \::/~~~~   \  \:\  /:/  \__\/  \:\   \  \::/      \__\/  \:\      \__\::/  \  \:\  /:/   \  \:\  ~~~ 
   \  \:\        \  \:\/:/        \  \:\   \  \:\           \  \:\     /__/:/    \  \:\/:/     \  \:\     
    \  \:\        \  \::/          \__\/    \  \:\           \__\/     \__\/      \  \::/       \  \:\    
     \__\/         \__\/                     \__\/                                 \__\/         \__\/ 
-----------------------------------------------------------------------------------------


]]


display.setStatusBar( display.HiddenStatusBar )

-- Load Plugins / 
local GGRating = require "GGRating"
local physicsData = (require "p").physicsData(.18)


-- Always set properties before initializing


if audio.supportsSessionProperty == true then
    --print("supportsSessionProperty is true")
    audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
end

local listener = function( event )
   
end

local alert = 
{
    title = "Rate Rotation.",
    caption = "Would you like to rate this app?", 
    buttons = { "Yes", "Not Yet", "Never" }
}

local rating = GGRating:new( 912297786, GGRating.Market.Apple, 8, alert, listener )


local physics = require( "physics")
physics.start( )
physics.setGravity( 0, 0 ) 
local kiip = require( "plugin.kiip")
--local math2d = require "math2d"
--local ads = require( "ads" )

local GGData = require("GGData")
--local crypto = require( "crypto" )

local box = GGData:new("storage")
--box:enableIntegrityControl( crypto.sha512, "vi#Nc|Wp[Ea|7NdIv`cM,LttIyO-U OL-Cu|a(<Kk NSom,#6O<Y6kb+zItb2h*g" )

local gameNetwork = require "gameNetwork"
local loggedIntoGC = false
--physics.setDrawMode( "hybrid" )

--Varibles in no specfic order

local localScore = 0
local burstStart = 3
local burstLength = 3
local rotate
local switchBG
local colors = {}
colors[1] = {39/255, 174/255, 96/255,1}
colors[2] = {41/255, 128/255, 185/255 ,1}
colors[3] = {142/255, 68/255, 173/255 ,1}
colors[4] = {230/255, 126/255, 34/255,1}
colors[5] = {192/255, 57/255, 43/255 ,1 }
colors[6] = {243/255, 156/255, 18/255,1}
local cY = display.contentCenterY
local cX = display.contentCenterX
--local music = audio.loadSound( "bgmusic.mp3" )
local bounce = audio.loadSound( "bounce.mp3" )
--audio.setVolume( 0.4, {channel = 1})

local audioMute 

if box:get("sound") == nil then

  audioMute = 1
else
  audioMute = box:get("sound")
end

local offset = 20
local count = 0
local last 
local rotateSpeed = 7
local speed = 250
local lvy,lvx = 0
local mainCol = colors[math.random( 1,5)]
local time1
local time2
local s = 1
local timerStarted = false
local segs = {}
local d
local gameStart = false
local adProvider = "admob"
local appID = "fnsjldblsfbhdlsfbsdjfhbslfbslfbslf"

display.setDefault("background" ,unpack(mainCol))




local left = display.newRect( 0 , cY, display.contentWidth, display.contentHeight+ 200 )
left:setFillColor(  211/255,211/255,211/255)
left.alpha = 0.01

local right = display.newRect( cX+ display.contentWidth/2 , cY, display.contentWidth, display.contentHeight+ 200 )
right:setFillColor(  211/255,211/255,211/255)
right.alpha = 0.01


local ball = display.newCircle( cX, cY,  5)
ball.hasCollided = false
ball:setFillColor( 0, 0 ,0)
ball.x = cX
ball.y = cY + offset
ball.currAngle = 0
--ball:scale(.2,.2)
physics.addBody( ball, "dynamic" ,  {density = 0, bounce = .95, radius = 5} )
ball.isBullet = true

-- Building segments
local seg1 = display.newImage( "seg1.png" )
seg1.x = cX
seg1.y = cY + offset  
seg1.rotation = 0
seg1.id = 1
physics.addBody( seg1, physicsData:get("seg1") )
seg1.bodyType = "static"
segs[1] = seg1


local seg2 = display.newImage( "seg1.png" )
seg2.x = cX
seg2.y = cY + offset 
seg2.rotation = 30
seg2.id = 2

physics.addBody( seg2, physicsData:get("seg1") )
seg2.bodyType = "static"
segs[2] = seg2


local seg3 = display.newImage( "seg1.png" )
seg3.x = cX
seg3.y = cY + offset 
seg3.rotation = 60
seg3.id = 3

physics.addBody( seg3, physicsData:get("seg1") )
seg3.bodyType = "static"
segs[3] = seg3

local seg4 = display.newImage( "seg1.png" )
seg4.x = cX
seg4.y = cY + offset 
seg4.rotation = 90
seg4.id = 4

physics.addBody( seg4, physicsData:get("seg1") )
seg4.bodyType = "static"
segs[4] = seg4


local seg5 = display.newImage( "seg1.png" )
seg5.x = cX
seg5.y = cY + offset 
seg5.rotation = 120
seg5.id = 5

physics.addBody( seg5, physicsData:get("seg1") )
seg5.bodyType = "static"
segs[5] = seg5


local seg6 = display.newImage( "seg1.png" )
seg6.x = cX
seg6.y = cY + offset 
seg6.rotation = 150
seg6.id = 6
seg6:scale(s,s)
physics.addBody( seg6, physicsData:get("seg1") )
seg6.bodyType = "static"

--seg6.isBodyActive = false
segs[6] = seg6

local seg7 = display.newImage( "seg1.png" )
seg7.x = cX
seg7.y = cY + offset 
seg7.rotation = 180
seg7.id = 7 

physics.addBody( seg7, physicsData:get("seg1") )
seg7.bodyType = "static"
segs[7] = seg7


local seg8 = display.newImage( "seg1.png" )
seg8.x = cX
seg8.y = cY + offset 
seg8.rotation = 210
seg8.id = 8

physics.addBody( seg8, physicsData:get("seg1") )
seg8.bodyType = "static"
segs[8] = seg8


local seg9 = display.newImage( "seg1.png" )
seg9.x = cX
seg9.y = cY + offset 
seg9.rotation = 240
seg9.id = 9

physics.addBody( seg9, physicsData:get("seg1") )
seg9.bodyType = "static"
segs[9] = seg9

local seg10 = display.newImage( "seg1.png" )
seg10.x = cX
seg10.y = cY + offset 
seg10.rotation = 270
seg10.id = 10

physics.addBody( seg10, physicsData:get("seg1") )
seg10.bodyType = "static"
segs[10] = seg10

local seg11 = display.newImage( "seg1.png" )
seg11.x = cX
seg11.y = cY + offset 
seg11.rotation = 300
seg11.id = 11

physics.addBody( seg11, physicsData:get("seg1") )
seg11.bodyType = "static"
segs[11] = seg11

local seg12 = display.newImage( "seg1.png" )
seg12.x = cX
seg12.y = cY + offset 
seg12.rotation = 330
seg12.id = 12

physics.addBody( seg12, physicsData:get("seg1") )
seg12.bodyType = "static"
segs[12] = seg12



--Build Bound Circle
physicsDate = nil
physicsData =  (require "p").physicsData(1.2)
local leftCir = display.newRect( 0 , 0 , 1, 1 )
leftCir.x = cX
leftCir.y = cY + 20 
leftCir.rotation = 0
leftCir.id = 69
physics.addBody( leftCir, physicsData:get("tempmo") )
leftCir.bodyType = "static"
leftCir.isVisible = false

local rightCir =  display.newRect( 0 , 0 , 1, 1 )
rightCir.x = cX
rightCir.y = cY + 20 
rightCir.id= 69
rightCir.rotation = 180
physics.addBody( rightCir, physicsData:get("tempmo") )
rightCir.bodyType = "static"
rightCir.isVisible = false





--End Bound Circle
local helpText1 =  display.newText("Keep The Ball in The Circle ", cX + 5, cY - 45 , "Roboto" , 18)
local helpText2 =  display.newText("Touch Any Side To Rotate ", helpText1.x , helpText1.y + 20, "Roboto" , 16)


local off2 = 1000
local gameOverBG = display.newImage( "circleBG.png" )
gameOverBG.x = cX - 10
gameOverBG.y = cY + 15 + off2
gameOverBG.width = 340
gameOverBG.height = 340


local scoreBack2 = display.newImage( "scoreBack.png" )
scoreBack2.x = cX  - 57
scoreBack2.y = cY + 10 + off2
scoreBack2.width = 70
scoreBack2.height = 70

local tryAgain = display.newImage( "tryAgainButton.png" )
tryAgain.x = cX - 60
tryAgain.y = cY + 100 + off2
tryAgain.width = 100
tryAgain.height = 40


local leaderButton = display.newImage( "leaderBoardButton.png" )
leaderButton.width = 45
leaderButton.height = 45
leaderButton.isVisible = true
leaderButton.x = cX + 30
leaderButton.y = cY + 98 + off2


local twitterButton = display.newImage( "twitter.png" )
twitterButton.width = 45
twitterButton.height = 45
twitterButton.isVisible = true
twitterButton.x = cX + 80
twitterButton.y = cY + 98 + off2



tryAgain:addEventListener( "touch", tryAgain)
twitterButton:addEventListener( "touch", twitterButton )
leaderButton:addEventListener( "touch", leaderButton )



--Gold Background
local goldBack = display.newImage( "bestGold.png" )
goldBack.x = cX  + 57
goldBack.y = cY + 10 + off2
goldBack.width = 70
goldBack.height = 70
goldBack.isVisible = false


local newButton = display.newImage( "newButton.png" )
newButton.x = cX  + 45
newButton.y = cY - 35 + off2
newButton.width = 30
newButton.height = 20
newButton.isVisible = false


--Silver Background
local silverBack = display.newImage( "bestSilver.png" )
silverBack.x = cX  + 57
silverBack.y = cY + 10 + off2
silverBack.width = 70
silverBack.height = 70
silverBack.isVisible = false

--Bronze Background
local bronzeBack = display.newImage( "bestBronze.png" )
bronzeBack.x = cX  + 57
bronzeBack.y = cY + 10 + off2
bronzeBack.width = 70
bronzeBack.height = 70

local sBack = display.newImage( "scoreBack.png" )
sBack.width = 70
sBack.height = 70
sBack.isVisible = false
sBack.x = cX - 57
sBack.y = cY + 10 + off2


print("audio mute")
print(audioMute)

local soundOff = display.newImage("muteIcon.png") 
soundOff.x = (display.contentWidth + display.screenOriginX) - 20
soundOff.y = (0 + display.screenOriginY) + 40
soundOff.width = 32
soundOff.height = 32
soundOff.isVisible = audioMute


local soundOn = display.newImage("playingIcon.png") 
soundOn.x = (display.contentWidth + display.screenOriginX) - 20
soundOn.y = (0 + display.screenOriginY) + 40
soundOn.width = 32
soundOn.height = 32
soundOff.isVisible = true

if audioMute == 1 then
  audio.setVolume( 1 )
  print("ss")
  soundOn.isVisible = true
  soundOff.isVisible = false
  audioMute = 0
else
  audio.setVolume( 0  )
  soundOn.isVisible = false
  soundOff.isVisible = true
  audioMute = 1
  

  
end


local sText = display.newText(localScore, 150 , 55 , "Roboto" , 30) 
sText.x = cX
sText.y = (0 + display.screenOriginY) + 40 
sText.isVisible = true

local highScore = display.newText("0", cX + 57 , cY + 10 , "Roboto" , 30) 
local highScoreValue
if box:get("highScore") == nil then
  highScoreValue = 0
else
  highScoreValue = box:get("highScore")
end
highScore.text = highScoreValue
highScore.y = cY + off2 + 10









--ads.init( adProvider, appID, adListener )



kiip.init(
{
    licenseKey = "nope.avi",
    testMode = false,
    appKey = "adddddksldnslfsbdflsfjbslkfbjslfbsnotlolthisisnotmykey4cafsadasfdsf8f0",
    appSecret = "hehehehehehlululululutrollolololo",  
    
    listener = function( event )
        -- Print the events key/pair values
        for k,v in pairs( event ) do
            print( k, ":", v )
        end
    end
})



-- Little function to switch backgrounds
local function switchBG(num)
  --Bronze
  if num == 1 then
    silverBack.isVisible = false
    goldBack.isVisible = false
    bronzeBack.isVisible = true

  --Silver
  elseif num == 2 then
    print("2")
    silverBack.isVisible = true
    goldBack.isVisible = false
    bronzeBack.isVisible = false


  --Gold
  elseif num == 3 then
    print("3")
    silverBack.isVisible = false
    goldBack.isVisible = true
    bronzeBack.isVisible = false


  
  end

end
--Set our intial BG
if highScoreValue > 45 then
    print("gold")

    switchBG(3)
  

else

    if highScoreValue > 30 then
        print("silver")
        switchBG(2)
    else
        print("bronze")
        switchBG(1)
    end

end


local function poptartHide(  )

  transition.to( highScore, {time = 1000, y = cY+ 1010} )
  transition.to( sBack , {time = 1000 , y = cY+1010} )
  transition.to( bronzeBack , {time = 1000 , y = cY+ 1010} )
  transition.to( silverBack , {time = 1000 , y = cY+1010} )
  transition.to( scoreBack2 , {time = 1000 , y = cY+1010 })
  transition.to( newButton , {time = 1000 , y = cY+965} )
  transition.to( goldBack , {time = 1000 , y = cY+1010} )
  transition.to( twitterButton , {time = 1000 , y = cY+1098} )
  transition.to( leaderButton , {time = 1000 , y = cY+1098} )
  transition.to( tryAgain , {time = 1000 , y = cY+1100} )
  transition.to( gameOverBG , {time = 1000 , y = cY+1015} )
  newButton.isVisible = false
  sText.x = cX
  sText.y = (0 + display.screenOriginY) + 40 

end

local function undhideall()
  for c = 1, 12 do
      segs[c].isVisible = true
      segs[c].isBodyActive = true
  end

end

local function switch()
  ball.isVisible = true
  ball.x = cX 
  ball.y = cY + offset
  
  undhideall()
  helpText1.alpha = 1 
  helpText2.alpha = 1
 
  localScore = 0
  sText.text = 0
  
  local num = math.random( 6)
  local col = colors[num]

  display.setDefault("background" ,unpack(col))
  

  gameStart = false

end


local function poptartShow( )
  rating:askToRate()
  if count % 10 == 0 then
    --Save kiip moment
    kiip.saveMoment({
        momentName = "A Super Prize!",
        value = 10,
        listener = function( event )
          -- Print the event table items
           for k,v in pairs( event ) do
             print( k, ":", v )
            end
        end,
    })

  end
  count = count + 1

  ball.isVisible = false
  sText.text = localScore
  sText.isVisible = false
  highScore.isVisible = true
  gameOverBG.isVisible = true
  scoreBack2.isVisible = true
  twitterButton.isVisible = true
  leaderButton.isVisible = true
  tryAgain.isVisible = true
  sText.x = cX
  sText.y = (0 + display.screenOriginY) + 70 + 1000
  sText.isVisible = true
  transition.to( highScore, {time = 1000 , y = cY+10} )
  transition.to( sText , {time = 1000 , x= cX - 57, y = cY + 10} )
  transition.to( sBack , {time = 1000 , y = cY+10} )
  transition.to( bronzeBack , {time = 1000 , y = cY+10} )
  transition.to( silverBack , {time = 1000 , y = cY+10} )
  transition.to( scoreBack2 , {time = 1000 , y = cY+10} )
  transition.to( newButton , {time = 1000 , y = cY-35} )
  transition.to( goldBack , {time = 1000 , y = cY+10} )
  transition.to( twitterButton , {time = 1000 , y = cY+98} )
  transition.to( leaderButton , {time = 1000 , y = cY+98} )
  transition.to( tryAgain , {time = 1000 , y = cY+100} )
  transition.to( gameOverBG , {time = 1000 , y = cY+15} )

  
  if localScore > highScoreValue then
    newButton.isVisible = true
    highScoreValue = localScore
    box:set("highScore" , highScoreValue)
    box:save()
    highScore.text = localScore
    if loggedIntoGC then
      
        gameNetwork.request( "setHighScore",
        {
          localPlayerScore = { category="rotate", value=highScoreValue },
          listener = requestCallback
        })

    end

    --Save kiip moment
    kiip.saveMoment({
        momentName = "A Super Prize!",
        value = 25,
        listener = function( event )
          -- Print the event table items
           for k,v in pairs( event ) do
             print( k, ":", v )
            end
        end,
    })

  end


  --Pick the right bg 
      
  if highScoreValue > 45 then
    print("gold")
    switchBG(3)
  
  else

    if highScoreValue > 30 then
        print("silver")
        switchBG(2)
    else
        print("bronze")
        switchBG(1)
    end

  end

end

local function rotate(angle)

  for c = 1, 12 do
      segs[c].rotation = segs[c].rotation + angle
      
    if( segs[c].rotation < 0 ) then 
        segs[c].rotation = segs[c].rotation + 360
    end

    if( segs[c].rotation >= 360 ) then 
        segs[c].rotation = segs[c].rotation - 360 
    end

  end

end

function rotateRight()

	for c = 1, 12 do
			
		segs[c].rotation = segs[c].rotation + rotateSpeed
		if( segs[c].rotation < 0 ) then 
            segs[c].rotation = segs[c].rotation + 360 
        end

	    if( segs[c].rotation >= 360 ) then 
            segs[c].rotation = segs[c].rotation - 360 
        end

	end

end

local function rotateLeft()
	for c = 1, 12 do
		--	print (ball:getLinearVelocity())

			segs[c].rotation = segs[c].rotation - rotateSpeed
			if( segs[c].rotation < 0 ) then segs[c].rotation = segs[c].rotation + 360 end
		if( segs[c].rotation >= 360 ) then segs[c].rotation = segs[c].rotation - 360 end
	end

end


local function tweakDir( obj )

  local mSqrt = math.sqrt 
  local mRad  = math.rad
  local mCos  = math.cos
  local mSin  = math.sin


  local function length( ... ) -- ( objA ) or ( x1, y1 )
    local len
      if( type(arg[1]) == "number" ) then
          len = mSqrt(arg[1] * arg[1] + arg[2] * arg[2])
      else
          len = mSqrt(arg[1].x * arg[1].x + arg[1].y * arg[1].y)
      end
    return len
  end

  local function angle2Vector( angle, tableRet )
    local screenAngle = mRad(-(angle+90))
    local x = mCos(screenAngle) 
    local y = mSin(screenAngle) 

    if(tableRet == true) then
      return { x=-x, y=y }
    else
      return -x,y
    end

  end

  local function normalize( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
    if( type(arg[1]) == "number" ) then
      local len = length( arg[1], arg[2], false )
      local x,y = arg[1]/len,arg[2]/len

      if(arg[3]) then
        return { x=x, y=y }
      else
        return x,y
      end

    else

      local len = length( arg[1], arg[2], true )
      local x,y = arg[1].x/len,arg[1].y/len
        
      if(arg[2]) then
        return x,y
      else
        return { x=x, y=y }
      end

    end

  end

  local function scale( ... ) -- ( objA, scale [, altRet] ) or ( x1, y1, scale, [, altRet]  )
    if( type(arg[1]) == "number" ) then

      local x,y = arg[1] * arg[3], arg[2] * arg[3]

      if(arg[4]) then
        return { x=x, y=y }
      else
        return x,y
      end

    else

      local x,y = arg[1].x * arg[2], arg[1].y * arg[2]
        
      if(arg[3]) then
        return x,y
      else
        return { x=x, y=y }
      end

    end
end




   local vx,vy = obj:getLinearVelocity()
   local angle = ball.currAngle + 180
   local len = length( vx, vy )

   local rand = math.random
   local offset = rand(30,45)
   if localScore > 25 then

    offset = rand(45,60)

   end

   angle = angle + offset
   angle = angle % 360
   rotate(offset + 15)
  
   local vec = angle2Vector( angle , true )
   vec = normalize(vec) -- not really needed (already done by angle2Vector)
   vec = scale( vec, len )

   obj:setLinearVelocity( vec.x, vec.y )

end   


local function col1(event)
    undhideall()
	local nextId = event.other.id + 6
	local pId
	if nextId > 12 then
		nextId = nextId - 12
	end
	if nextId == 12 then
		pId = 1
	else
		pId = nextId+1
	end

  segs[nextId].isVisible = false
	segs[pId].isVisible = false
  local a =(segs[nextId].rotation + 180)%360
  local b = (segs[pId].rotation + 180)%360
  id1 = nextId
  id2 = pId
  print("rotation1: " .. a )
  print("rotation2: " .. b )
	segs[nextId].isBodyActive = false 
	segs[pId].isBodyActive = false
	
end

local function col2(event)
    undhideall()

	local id1 = event.other.id + 6
	local id2 = id1 + 1
	
	if id1 > 12 then
		id1 = id1 - 12

	end
	if id1 == 12 then
		id2 = 1

	else
		id2 = id1 +1

	end

	local id3 = event.other.id
	local id4 
	if id3 == 12 then
		id4 = 1
	else
		id4 = id3 +1
	end
	



	
    segs[id1].isVisible = false
	segs[id2].isVisible = false
	segs[id3].isVisible = false
	segs[id4].isVisible = false

	segs[id1].isBodyActive = false 
	segs[id2].isBodyActive = false
	segs[id3].isBodyActive = false 
	segs[id4].isBodyActive = false

end

local function col3(event)
    undhideall()

	local id1 = event.other.id + 6
	local id2
	
	if id1 > 12 then
		id1 = id1 - 12

	end

	if id1 == 12 then
		id2 = 1

	else
		id2 = id1 +1

	end

	local id3 = id2 + 3
	local id4 
	if id3 > 12 then
		id3 = id3 - 12
		id4 = id3 + 1
		
	elseif id3 == 12 then
		id4 = 1

	else
		id4 = id3 + 1

	end

	local id5 = id4 + 3
	local id6
	if id5 > 12 then
		id5 = id5 - 12
		id6 = id5 + 1
	elseif id5 == 12 then
		id6 = 1
	else
		id6 = id5 +1
	end
	
    segs[id1].isVisible = false
	segs[id2].isVisible = false
	segs[id3].isVisible = false
	segs[id4].isVisible = false
	segs[id5].isVisible = false
	segs[id6].isVisible = false

	segs[id1].isBodyActive = false 
	segs[id2].isBodyActive = false
	segs[id3].isBodyActive = false 
	segs[id4].isBodyActive = false
	segs[id5].isBodyActive = false 
	segs[id6].isBodyActive = false
  		
end

local function col4(event)

	undhideall()

	local id1 = event.other.id + 6
	local id2

	
	if id1 > 12 then
		id1 = id1 - 12
	end
	if id1 == 12 then
		id2 = 1
	else
		id2 = id1 +1
	end

    local id3 = id2 + 2
    local id4
	
	if id3 > 12 then
		id3 = id3 - 12
		id4 = id3 + 1
		
	elseif id3 == 12 then
		id4 = 1
	else
		id4 = id3 + 1

	end

	local id5 = id4 + 2
	local id6
	
	if id5 > 12 then
		id5 = id5 - 12
		id6 = id5 + 1
	elseif id5 == 12 then
		id6 = 1
	else
		id6 = id5 +1
	end

	local id7 = id6 + 2
	local id8
	
	if id7 > 12 then
		id7 = id7 - 12
		id8 = id7 + 1
	elseif id7 == 12 then
		id8 = 1
	else
		id8 = id7 +1
	end

    segs[id1].isVisible = false
	segs[id2].isVisible = false
	segs[id3].isVisible = false
	segs[id4].isVisible = false
	segs[id5].isVisible = false
	segs[id6].isVisible = false
	segs[id7].isVisible = false
	segs[id8].isVisible = false

	segs[id1].isBodyActive = false 
	segs[id2].isBodyActive = false
	segs[id3].isBodyActive = false 
	segs[id4].isBodyActive = false
	segs[id5].isBodyActive = false 
	segs[id6].isBodyActive = false
	segs[id7].isBodyActive = false 
	segs[id8].isBodyActive = false
  		
end

local function col5(event)
    undhideall()

	local id1 = event.other.id + 6
    local id2 = id1 + 1
	
	if id1 > 12 then
		id1 = id1 - 12
	end

	if id1 == 12 then
		id2 = 1
	else
		id2 = id1 +1
	end

    local id3 = event.other.id
    local id4 
    
    local id6

    if id2 == 12 then
    	id6 = 1
    else
    	id6 = id2 + 1
    end

	if id3 == 12 then
		id4 = 1
	else
		id4 = id3 +1
	end
  

	if id4 == 12 then
    	id5 = 1
    else
    	id5 = id4 + 1
    end

    segs[id1].isVisible = false
	segs[id2].isVisible = false
	segs[id3].isVisible = false
	segs[id4].isVisible = false
	segs[id5].isVisible = false
	segs[id6].isVisible = false

	segs[id1].isBodyActive = false 
	segs[id2].isBodyActive = false
	segs[id3].isBodyActive = false 
	segs[id4].isBodyActive = false
	segs[id5].isBodyActive = false 
	segs[id6].isBodyActive = false	

end

local function onLocalCollision(self, event)

	
  	if event.phase == "began"  then

  		if event.other.id == 69 then 
            ball.isVisible = false
            ball:setLinearVelocity( 0, 0 )
            poptartShow()

		else
            
            local function delay( ... )
  		

                math.randomseed(  os.time() )

  			    local random = math.random
                local d
                 -- Ease people in , only one hole until 3 points
                if localScore < 3 then
                    d = 1

                
                else
                    d = random(2,5)
                    --prevent getting the same shape
                    if d == last and localScore > 2 then

                        if d == 5 then 
                            d = 2 
                        else
                            d = d + 1
                        end

                     end


                end

                if localScore > 20 then
                  --If score greater than 20 we will have random bursts of only 4 parts

                  local num = localScore % 10
                  print(num)
                  if num >= burstStart and num <= (burstStart + burstLength) then
                      d = 4
                      print("all")
                      if num == (burstStart + burstLength) then
                          burstStart = random(1,5)
                          burstLength = random(1,3)
                          print("Burst Start: " .. burstStart)
                          print("Burst End " .. burstStart + burstLength)
                      end

                  end

                end
                print(d)
                last = d
          

  				if event.other.id == nil then
  					print("I'm Confuzzeled") -- In very rare cases event.other.id = nil , still don't know why
  				elseif d == 1 then
                    col1(event)

  				elseif d == 2 then
  					col2(event)

  				elseif d == 3 then
  					col3(event)

  				elseif d == 4 then
  					col4(event)

  				elseif d == 5 then
  					col5(event)

  				end

  			end

  	

  		if ball.hasCollided == false then
			ball.hasCollided = true --this prevents double collisons

            localScore = localScore + 1

            local vx,vy = ball:getLinearVelocity() 
            local mCeil = math.ceil 
            local mAtan2 = math.atan2
            local mPi = math.pi
            local function vector2Angle( ... ) -- ( objA ) or ( x1, y1 )

              local angle
              if( type(arg[1]) == "number" ) then
                angle = mCeil(mAtan2( (arg[2]), (arg[1]) ) * 180 / mPi) + 90
              else
                angle = mCeil(mAtan2( (arg[1].y), (arg[1].x) ) * 180 / mPi) + 90
              end

              return angle

            end
            ball.currAngle = vector2Angle( vx, vy )
            print("Ball Angle: " .. ball.currAngle)

			   if localScore == 3 then
               rotateSpeed = 10
				        speed = 300
				        print("score increased")
		    	elseif localScore == 10 then
                rotateSpeed = 12
                speed = 350
                print("score increased")

            elseif localScore == 15 then
                rotateSpeed = 13
                speed = 400
                print("score increased")

            elseif localScore == 25 then
                speed = 450
                print("score increased")
            elseif localScore == 28 then
               speed = 475
                print("score increased")

             elseif localScore == 28 then
               speed = 500
                print("score increased")

               elseif localScore == 35 then
               speed = 550
                print("score increased")

              elseif localScore == 40 then
               speed = 600
                print("score increased")

            end
				sText.text = localScore
				ball.vy = 0
				ball.vx = 0
                audio.play( bounce , {channel = 0, loops = 0})

				time1 = timer.performWithDelay(1, function() ball.hasCollided = false end, 1)
                timer.performWithDelay(1, function() tweakDir( self ) end )
				time2 = timer.performWithDelay( 1, delay , 1 )
				

  		end
  		   		
	end	
  	
  		   
  	elseif event.phase == "ended" then

    
      local xForce,yForce = ball:getLinearVelocity()
      local force = math.floor(math.sqrt( (xForce ^ 2) + (yForce ^ 2)))
      print("Speed : " .. speed)
      print("Speed low:" .. speed-100)

      if force < speed then
        xForce = xForce * 1.05
        yForce = yForce * 1.05

      elseif force  < 250 then
        --Something went horribly wrong we need to jump the speed back up
        print("speed")

        local tDiff = speed/force
        print("Reduce Critical: " .. tDiff)
        xForce = xForce * tDiff
        yForce = yForce * tDiff

      else  
        local tDiff = speed/force
        print("Reduce: " .. tDiff)
        xForce = xForce * tDiff
        yForce = yForce * tDiff

      end
 
      ball:setLinearVelocity( xForce, yForce )
      print("Force: " .. force)
     

    end


end
	--Where we do the switch of segments and stuff




ball.collision = onLocalCollision
ball:addEventListener( "collision", ball )

function right:touch( event )
	
    if event.phase == "began" then
    	if gameStart == false then
            --audio.play (music , { channel = 1, loops = -1, fadein = 500 } )
    		ball:setLinearVelocity(0 , 250 )
    		gameStart = true
          transition.to( helpText1 , {time = 250 , alpha = 0} )
           transition.to( helpText2, {time = 250 , alpha = 0} )
    	end
       
        timerStarted = true
       	rotateTimer = timer.performWithDelay(10, rotateRight, 0)
       	transition.to( right, {time = 300, alpha = .2 } )
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
        	timer.cancel( rotateTimer )
        	transition.to( right, {time = 300, alpha = .01 } )
            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
	return true

end 

right:addEventListener( "touch", right )


function left:touch( event )

    if event.phase == "began" then
    		if gameStart == false then
          -- audio.play (music , { channel = 1, loops = -1, fadein = 500 } )
           ball:setLinearVelocity(0 , 250 )
    		   gameStart = true
    
           transition.to( helpText1 , {time = 250 , alpha = 0} )
           transition.to( helpText2, {time = 250 , alpha = 0} )
    	    end
        
        timerStarted = true
       	rotateTimer = timer.performWithDelay(10, rotateLeft, 0)
       	transition.to( left, {time = 300, alpha = .2 } )
       
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
        	timer.cancel( rotateTimer )
        	transition.to( left, {time = 300, alpha = .01 } )
            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
	return true

end 

left:addEventListener( "touch", left )

function soundOn:touch( event )
    
    if event.phase == "began" then

        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" then
            print("touch on")

            print(audioMute)
            if audioMute == 0 then
                print("audiomuete")
                print("aa")
                audio.setVolume( 0  )
                soundOn.isVisible = false
                soundOff.isVisible = true
                audioMute = 1
                box:set("sound" , 0)
                box:save()
                print("1switched: " .. box:get("sound"))

            end

            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true

end 

soundOn:addEventListener( "touch", soundOn)



function soundOff:touch( event )
    
    if event.phase == "began" then
       
       
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" then
            print("touch off")
            if audioMute == 1 then

                audio.setVolume( 1 )
                print("ss")
                soundOn.isVisible = true
                soundOff.isVisible = false
                audioMute = 0
                box:set("sound" , 1)

                box:save()
                print("0switched: " .. box:get("sound"))
               
            end

            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true

end 

soundOff:addEventListener( "touch",  soundOff )

--This is where my gameCenter stuff goes


--




function tryAgain:touch( event )
    if event.phase == "began" then
        -- set touch focus
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
       if event.phase == "ended" then
          
            poptartHide()
            switch()

            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true

end 



function leaderButton:touch( event )
    if event.phase == "began" then
        -- set touch focus
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" then

           

                if loggedIntoGC == true then
                --show leaderboard
                    -- native.showAlert( "Success! Logged in", "", { "OK" } )
                     gameNetwork.show( "leaderboards", { leaderboard={  category="rotate",timeScope="Week" }} )
                end


            --native.showAlert( "Not Logged in", "", { "OK" } )
            -- reset touch setFocus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true

end 

local function initCallback( event )
     if event.type == "showSignIn" then
      
    elseif event.data then
        loggedIntoGC = true
         --native.showAlert( "Success!", "", { "OK" } )

        
    end

 
end

local function onSystemEvent( event ) 
    if ( event.type == "applicationStart" ) then

            gameNetwork.init( "gamecenter", initCallback )
      
       
  
        return true
    end
end

Runtime:addEventListener( "system", onSystemEvent )


function twitterButton:touch( event )
    if event.phase == "began" then
        -- set touch focus
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "ended" then
          
            --sharePanel:show()

            --showTweetPanel()
            local options =
            {
              message = "I just scored " .. localScore .. " on @rotationgame. Think you can beat me? #RotationGame "
            }
            native.showPopup( "twitter" , options)
            
            -- reset touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true

end 



	