--Proto RGB Led Server
--Created @ 2016-01-25 by Yann Vasseur
--Site:  http://reactor.fr
--For ESP12E Dev kit

-- Config
local SSID = "YOURID"
local WIFIKEY = "YOURKEY"
local modeStation = true


local powerPin, redPin, greenPin, bluePin = 4, 6, 7, 8
	

httpserver = function () 

	start_init_color()
  
    srv = net.createServer(net.TCP)       
    srv:listen(80,function(conn)         
		conn:on("receive",function(conn,request)           
			print("receive")
			print(request)	
			
			local rstr = string.match(request, 'r=%d+')
			local gstr = string.match(request, 'g=%d+')
			local bstr = string.match(request, 'b=%d+')
			local onstr = string.match(request, 'on=%d')
			
			--Power On/Off
			if onstr ~= nil then
				print(onstr)
				local onint = string.match(onstr, '%d')				
				if onint ~= nil then
					print(onint)
					gpio.mode(powerPin, gpio.OUTPUT)
					if onint == 1 then						
						gpio.write(powerPin, gpio.HIGH)
					else						
						gpio.write(powerPin, gpio.LOW)
					end				
				end				
			end
			
			--Set color to led			
			if rstr ~= nil and  gstr ~= nil and  bstr ~= nil then
				--print(rstr .. ' ' .. gstr .. ' ' .. bstr)
				local rint = string.match(rstr, '%d+')
				local gint = string.match(gstr, '%d+')
				local bint = string.match(bstr, '%d+')
				--print(rint .. ' ' .. gint .. ' ' .. bint)
				if rint ~= nil and gint ~= nil and bint ~= nil then
					print('R:' .. rint .. ' G:' .. gint .. ' B:' .. bint)
					ledRGB(rint, gint, bint)
				else
					print('no rgb value in request (int)')
				end				
			else
				print('no rgb value in request')
			end
			
			conn:send("200 ok");  
			conn:close();
			collectgarbage();	
		end)         
	
    end)  	
	print('Server http on')		
	start_animcolor()
end    

start_init_color = function() 
	
	--Power pin 
	gpio.mode(powerPin, gpio.OUTPUT)
	gpio.write(powerPin, gpio.HIGH)
	
	pwm.setup(redPin, 500, 512)
	pwm.setup(greenPin, 500, 512)
	pwm.setup(bluePin, 500, 512)
	pwm.start(redPin)
	pwm.start(greenPin)
	pwm.start(bluePin)
	print('RGB led strip set on pin rgb 6 7 8')
	
	collectgarbage();
end

start_animcolor = function() 

	ledRGB(255, 0, 0)
	print('Rouge')
	tmr.delay(2000000)

	ledRGB(255, 255, 0)
	print('Jaune')
	tmr.delay(2000000)

	ledRGB(0, 255, 0)
	print('Vert')
	tmr.delay(2000000)
	
	collectgarbage();
end
 
function led(r, g, b)
   pwm.setduty(redPin, r)
   pwm.setduty(greenPin, g)
   pwm.setduty(bluePin, b)
end

function ledRGB(r, g, b)
   led(1023 - 4 * r, 1023 - 4 * g, 1023 - 4 * b)
   collectgarbage();
end



-- ****************
-- * MAIN PROGRAM *
-- ****************
print("******** Main - Led Strip controler ********")

if modeStation then
	--**** MODE STATION AP Connexion to my live box
	wifi.setmode(wifi.STATION)
	wifi.sta.config(SSID, WIFIKEY)
	wifi.sta.connect()
	
	-- Connect to the WiFi access point.
	-- Once the device is connected, you may start the HTTP server.

	if (wifi.getmode() == wifi.STATION) or (wifi.getmode() == wifi.STATIONAP) then
		local joinCounter = 1
		local joinMaxAttempts = 5
		tmr.alarm(0, 3000, 1, function()
			print('Connecting to WiFi Access Point, Attempt ' .. joinCounter .. ' over ' .. joinMaxAttempts)
			local ip = wifi.sta.getip()	
			if ip == nil and joinCounter < joinMaxAttempts then		  
				joinCounter = joinCounter +1
			else
				if joinCounter == joinMaxAttempts then
					print('Failed to connect to WiFi Access Point.')					
				else
					print('IP: ',ip)
					
					httpserver()
				end			
				tmr.stop(0)
				joinCounter = nil
				joinMaxAttempts = nil
				collectgarbage()
			end
		end)
	end
else
	--**** MODE AP
	wifi.setmode(wifi.SOFTAP) 
	local cfg={}
	cfg.ssid="DoitWiFi"
	cfg.pwd="12345678"
	wifi.ap.config(cfg)

	cfg={}
	cfg.ip="192.168.2.111"
	cfg.netmask="255.255.255.0"
	cfg.gateway="192.168.2.1"
	print("IP Info: \nIP Address: ", cfg.ip)
    print("Netmask: ", cfg.netmask)
    print("Gateway Addr: ", cfg.gateway,'\n')
	  
	wifi.ap.setip(cfg)

	httpserver()
end







