require "action_view"
include ActionView::Helpers::NumberHelper

class Bar
	
	def initialization(name,data)
		@name =name
		@dataIiko = data
	end

	def BarF()

		 #ГрафикСебест%

        filterDeleted = {"DeletedWithWriteoff" => {"filterType"=> "IncludeValues",
                                           "values"=>["NOT_DELETED"]  } }

        data = @dataIiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["ProductCostBase.Percent"], str: "CURRENT_MONTH",filters: filterDeleted)
        #data = $iikoM.IikoPostRequestForSebesMounth("PostForSebes%.json","CURRENT_MONTH")
        prev = ""
        sum = 0
	    countDay = 0
	    pointsSebesSum = []
	    sebesSum = []
	    labelsBarSebesSum = []
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sum+=(iikos['ProductCostBase.Percent']*100).round(2)
                pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum }
				countDay+=1

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    pointsSebesSum << { x: prev.next_day.strftime('%d-%m') , y: sum/countDay }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sum+=(iikos['ProductCostBase.Percent']*100).round(2)
				countDay+=1
                pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum/countDay }

              else
                sum+=(iikos['ProductCostBase.Percent']*100).round(2)
				countDay+=1
                pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum/countDay }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")

              end
        end

        pointsSebesSum.each do |i|
            sebesSum<<i[:y]
        end

        pointsSebesSum.each do |i|
            labelsBarSebesSum<<i[:x]
        end

		   data = [
            {
              label: 'Себест %',
              data: pointsSebesSum,
              backgroundColor: [ 'rgba(128, 128, 90,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * labelsBarSebesSum.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSebes'+@name, { labels: labelsBarSebesSum, datasets: data })
         #График НАКОПЛЕНИЕ ВЫРУЧКИ

        #ПЕРВАЯ ЧАСТЬ
        data = @dataIiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["DishDiscountSumInt"], str: "LAST_MONTH")
        #data = $iikoM.IikoPostRequestForSebesMounth("POST.json","LAST_MONTH")
        prev = ""
        sumLast=0
        sumCurrent=0
        pointsSum = []
        dishDiscountSumIntsSum = []
        labelsBarSum = []
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sumLast+=iikos['DishDiscountSumInt']
                pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    pointsSum << { x: prev.next_day.strftime('%d-%m') , y: sumLast }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sumLast+=iikos['DishDiscountSumInt']
                pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }
              else
                sumLast+=iikos['DishDiscountSumInt']
                pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        pointsSum.each do |i|
            dishDiscountSumIntsSum<<i[:y]
        end

        pointsSum.each do |i|
            labelsBarSum<<i[:x]
        end
        #ВТОРАЯ ЧАСТЬ
        data = @dataIiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["DishDiscountSumInt"], str: "CURRENT_MONTH")
        #data = $iikoM.IikoPostRequestForSebesMounth("POST.json","CURRENT_MONTH")
        prev = ""

        pointsSum2 = []
        dishDiscountSumIntsSum2 = []
        labelsBarSum2 = []
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sumCurrent+=iikos['DishDiscountSumInt']
                pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    pointsSum2 << { x: prev.next_day.strftime('%d-%m') , y: sumCurrent }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sumCurrent+=iikos['DishDiscountSumInt']
                pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }
              else
                sumCurrent+=iikos['DishDiscountSumInt']
                pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        pointsSum2.each do |i|
            dishDiscountSumIntsSum2<<i[:y]
        end

        pointsSum2.each do |i|
            labelsBarSum2<<i[:x]
        end

        data = [
            {
              label: 'Прошлый',
              data: dishDiscountSumIntsSum2,
              backgroundColor: [ 'rgba(128, 166, 255,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * labelsBarSum2.length,
              borderWidth: 1,

            },
            {
              label: 'Текущий',
              data: dishDiscountSumIntsSum2,
              backgroundColor: [ 'rgba(82, 204, 0,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * labelsBarSum2.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSum'+@name, { labels: labelsBarSum2, datasets: data })

        #График выручки по дням за месяц

        data = @dataIiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["DishDiscountSumInt"], str: "CUSTOM_MONTH")
        
        #data = $iikoM.IikoPostRequest("POST.json")
        prev = ""
        dishDiscountSumInts = []
        points = []
        labelsBar = []
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    points << { x: prev.next_day.strftime('%d-%m') , y: 0 }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
              else
                points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        points.each do |i|
            dishDiscountSumInts<<i[:y]
        end

        points.each do |i|
            labelsBar<<i[:x]
        end

        data = [
            {
              label: 'Выручка',
              data: dishDiscountSumInts,
              backgroundColor: [ 'rgba(128, 128, 128,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * labelsBar.length,
              borderWidth: 1,

            }
        ]
        send_event('barchart'+@name, { labels: labelsBar, datasets: data })

        #График среднего чека по дням


        data = @dataIiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["DishDiscountSumInt.average"], str: "CUSTOM_MONTH")
        #data = $iikoM.IikoPostRequest("SrCheck.json")
        prev = ""

        dishDiscountSumIntsSr = []
        pointsSr = []
        labelsBarSr =[]

        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    pointsSr << { x: prev.next_day.strftime('%d-%m') , y: 0 }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
              else
                pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
        end

        pointsSr.each do |i|
            dishDiscountSumIntsSr<<i[:y]
        end

        pointsSr.each do |i|
            labelsBarSr<<i[:x]
        end

        data = [
            {
              label: 'Средний чек',
              data: dishDiscountSumIntsSr,
              backgroundColor: [ '#ff9900' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * labelsBarSr.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSr'+@name, { labels: labelsBarSr, datasets: data })
    end
	
end