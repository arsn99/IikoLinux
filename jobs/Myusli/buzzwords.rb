load 'lib/Buzzwords_Script.rb'
buzzMyusli = Buzz.new
buzzFarm = Buzz.new
SCHEDULER.in '20s' do
	buzzMyusli.initialization('Myusli',$iikoM)
	buzzFarm.initialization('Farm',$iikoF)
end

SCHEDULER.every '15m', :first_in => 30 do |job|
  buzzMyusli.BuzzF()
  buzzFarm.BuzzF()
end
