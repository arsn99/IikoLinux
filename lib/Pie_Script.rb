class Pie
	
	def initialization(name,data)
		@@name =name
		@@dataIiko = data
	end

	def PieF()
		pointsPie = []
		labelsPie = []
		dishDiscountSumIntPie = []

		# Типы оплат
        data = @@dataIiko.IikoPostRequestSTR(groupByColFields: ["PayTypes"],aggregateFields: ["UniqOrderId","DishDiscountSumInt"], str: "CURRENT_MONTH")
		#data = $iikoM.IikoPostRequestForSebesMounth("POSTforBUZZ.json","CURRENT_MONTH")

		data['data'].each do |iikos|
			  pointsPie << { type:iikos['PayTypes'] , sum: iikos['DishDiscountSumInt'] }

		end
		pointsPie = pointsPie.sort_by { |h| -h[:sum]}

		dataMoreInfoSum = 0

		pointsPie.each do |i|
            if i[:sum] != 0
            	dataMoreInfoSum+=i[:sum]
                dishDiscountSumIntPie<<i[:sum]
                labelsPie<<i[:type]+" : "+ number_with_delimiter(i[:sum].round, delimiter: " ").to_s
            end

		end
		dataMoreInfoSum =  number_with_delimiter(dataMoreInfoSum.round, delimiter: " ")
	
		data = [
			{
			  # Create a random set of data for the chart
			  data: dishDiscountSumIntPie ,
			  backgroundColor: [
				'#F7464A',
				'#46BFBD',
				'#FDB45C',
				'#FFC000',
				'#FFCE56',
				'#000E56',
				'#FFCE56',
				'#CCCEC6',
				'#CC000E',
				'#CCFFFE',
				'#FCBEDE'
			  ],
			  hoverBackgroundColor: [
				'#FF6384',
				'#36A2EB',
				'#F00056',
				'#FFC000',
				'#FFCE56',
				'#000E56',
				'#FFCE56',
				'#CCCEC6',
				'#CC000E',
				'#CCFFFE',
				'#FCBEDE'
			  ],
			},
		  ]
		  send_event('piechart'+@@name, { labels: labelsPie, datasets: data ,moreinfo:dataMoreInfoSum})
	end
end