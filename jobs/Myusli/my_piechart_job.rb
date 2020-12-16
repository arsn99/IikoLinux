load 'lib/Pie_Script.rb'

pieMyusli = Pie.new
pieFarm = Pie.new
SCHEDULER.in '20' do
	pieMyusli.initialization('Myusli',$iikoM)
	pieFarm.initialization('Farm',$iikoF)
end

SCHEDULER.every '15m', :first_in => 30 do |job|
	pieMyusli.PieF()
	pieFarm.PieF()
end
