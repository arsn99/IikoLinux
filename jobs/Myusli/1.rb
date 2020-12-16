 #Myusli
 load 'lib/Iiko.rb'

 $iikoM = Iiko::IikoRequests.new
 $iikoM.initialization('admin','Cnhtc101%',"https://myusli.iiko.it:443/",true)

 $iikoF = Iiko::IikoRequests.new
 $iikoF.initialization('admin','Cnhtc101%',"http://46.0.197.153:8080/",false)

 #$iiko.TelegramMessage()
 begin
	$iikoM.GetToken()
	$iikoF.GetToken()
 rescue
	puts "Токен не получен."
	$iikoM.Finalize()
	$iikoF.Finalize()
 end

 SCHEDULER.every '300s', :first_in => '100s' do |job|
	#$iikoM.CheckToken()
	#$iikoF.CheckToken()
	$iikoM.Finalize()
	$iikoF.Finalize()
end
