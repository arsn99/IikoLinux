load 'lib/Sebest_Script.rb'
sebesMyusli = Sebest.new
sebesFarm = Sebest.new
SCHEDULER.in '20s' do
	sebesMyusli.initialization('Myusli',$iikoM)
	sebesFarm.initialization('Farm',$iikoF)
end

SCHEDULER.every '15m', :first_in => 30 do |job|

	sebesMyusli.SebesF()
	sebesFarm.SebesF()

end
