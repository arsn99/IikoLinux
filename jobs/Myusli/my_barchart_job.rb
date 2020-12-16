
barMyusli = Bar.new
barFarm = Bar.new
SCHEDULER.in '20' do
  barMyusli.initialization('Myusli',$iikoM)
  barFarm.initialization('Farm',$iikoF)
end

SCHEDULER.every '15m', :first_in => 30 do |job|
  barMyusli.BarF()
  barFarm.BarF()
end
