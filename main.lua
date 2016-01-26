--Proto RGB 
--Created @ 2016-01-25 by Yann Vasseur
--Site:  http://reactor.fr
--For ESP12E Dev kit

-- Config
local SSID = "YOURWIFIID"
local WIFIKEY = "YOURKEY"
local modeStation = true

-- ****************
-- * MAIN PROGRAM *
-- ****************
print("******** Main - Led Strip controler ********")

--Init
w = loadfile("webserver.lc")
w()

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










