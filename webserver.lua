
httpserver = function () 

	start_init_color()
  
    srv = net.createServer(net.TCP)       
    srv:listen(80,function(conn)         
		conn:on("receive",function(conn,request)           
			print("receive")
			--print(request)	
			
			local rstr = string.match(request, 'r=%d+')
			local gstr = string.match(request, 'g=%d+')
			local bstr = string.match(request, 'b=%d+')

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
end    

start_init_color = function() 

	redPin, greenPin, bluePin = 6, 7, 8
	pwm.setup(redPin, 500, 512)
	pwm.setup(greenPin, 500, 512)
	pwm.setup(bluePin, 500, 512)
	pwm.start(redPin)
	pwm.start(greenPin)
	pwm.start(bluePin)
	print('RGB led strip set on pin rgb 6 7 8')

	ledRGB(255, 0, 0)
	print('Rouge')
	tmr.delay(2000000)

	ledRGB(255, 255, 0)
	print('Jaune')
	tmr.delay(2000000)

	ledRGB(0, 255, 0)
	print('Vert')
	tmr.delay(2000000)
end
 
function led(r, g, b)
   pwm.setduty(redPin, r)
   pwm.setduty(greenPin, g)
   pwm.setduty(bluePin, b)
end

function ledRGB(r, g, b)
   led(1023 - 4 * r, 1023 - 4 * g, 1023 - 4 * b)
end
