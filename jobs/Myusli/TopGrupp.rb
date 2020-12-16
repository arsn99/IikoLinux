load 'lib/TopGrupp_Script.rb'
topMyusli = TopGrup.new
topFarm = TopGrup.new
SCHEDULER.in '20' do
	topMyusli.initialization('Myusli',$iikoM)
	topFarm.initialization('Farm',$iikoF)
end

SCHEDULER.every '15m', :first_in => 30 do |job|
  topMyusli.TopGrupF()
  topFarm.TopGrupF()
end
