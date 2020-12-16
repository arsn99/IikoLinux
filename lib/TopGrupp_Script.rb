require "action_view"
include ActionView::Helpers::NumberHelper

class TopGrup
	
	def initialization(name,data)
		@name =name
		@dataIiko = data
	end

	def TopGrupF()
		dataGruppM = @dataIiko.IikoPostRequestForSebesMounth("PostPoGruppavBlud.json","CURRENT_MONTH")
		pointsGrM= []
		laGrM = []
    	sum = 0
		dataGruppM['data'].each do |iikos|
              if iikos['DishGroup'].nil?
                next
              end
			  if iikos['DishGroup'].length < 17
				pointsGrM << { sum:iikos['DishDiscountSumInt'] , type: iikos['DishGroup'] }
                sum+=iikos['DishDiscountSumInt']
			  else
				nameS = ""
				lengthS = iikos['DishGroup'].split(" ").length
				i = 0
				iikos['DishGroup'].split(" ").each_with_index do |name,k|
					if k==0 && k!=lengthS-1
						nameS <<" "+name
						next
					end

					if name.length > 3
						name=name.slice(0..2)+"."
					end
					nameS <<" "+name
				end
				pointsGrM << { sum:iikos['DishDiscountSumInt'] , type: nameS }
                sum+=iikos['DishDiscountSumInt']
			  end

		end

		pointsGrM = pointsGrM.sort_by { |h| -h[:sum]}
		laGrM<<{label:"Блюда",value:"Сум."}
		pointsGrM.each_with_index do |i,k|
			if k>19
				break
			end
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			laGrM<<{label:(k+1).to_s+". "+i[:type],value:str}

		end
		sum = number_with_delimiter(sum.round, delimiter: " ")
        send_event('TopGruppM'+@name, { items: laGrM ,moreinfo:Date.today.strftime("%B"),sum:sum})
		#Топ по группам блюд %%%%

		dataGruppMPrecent = @dataIiko.IikoPostRequestForSebesMounth("PostPoGruppavBlud%.json","CURRENT_MONTH")
		pointsGrMPr= []
		laGrMPr = []

		dataGruppMPrecent['data'].each do |iikos|
              if (iikos['DishGroup']<=>"ОДНОРАЗОВАЯ ПОСУДА")==0 or iikos['DishGroup'].nil?
                next
              end
			  if iikos['DishGroup'].length < 20
				pointsGrMPr << { sum:(iikos['ProductCostBase.Percent']*100).round(2) , type: iikos['DishGroup'] }
			  else
				nameS = ""
				lengthS = iikos['DishGroup'].split(" ").length
				i = 0
				iikos['DishGroup'].split(" ").each_with_index do |name,k|
					if k==0 && k!=lengthS-1
						nameS <<" "+name
						next
					end
					if name.length > 5
						name=name.slice(0..4)+"."
					end
					nameS <<" "+name
				end
				pointsGrMPr << { sum:iikos['ProductCostBase.Percent'] , type: nameS }

			  end
		end

		pointsGrMPr = pointsGrMPr.sort_by { |h| -h[:sum]}
		laGrMPr<<{label:"Блюда",value:"Проц."}
		pointsGrMPr.each_with_index do |i,k|
			if k>19
				break
			end
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			laGrMPr<<{label:(k+1).to_s+". "+i[:type],value:str}

		end
		send_event('TopGruppMPrecent'+@name, { items: laGrMPr ,moreinfo:Date.today.strftime("%B")})
		#Топ по группам блюд Count
        sum = 0
		dataGruppMPCount = @dataIiko.IikoPostRequestForSebesMounth("PostPoGruppavBludCount.json","CURRENT_MONTH")
		pointsGrMCount= []
		laGrMCount = []
		dataGruppMPCount['data'].each do |iikos|
              if iikos['DishGroup'].nil?
                next
              end
			  if iikos['DishGroup'].length < 17
				 pointsGrMCount << { sum:iikos['DishAmountInt'] , type: iikos['DishGroup'] }
                 sum+=iikos['DishAmountInt']
			  else
				nameS = ""
				lengthS = iikos['DishGroup'].split(" ").length
				i = 0
				iikos['DishGroup'].split(" ").each_with_index do |name,k|
					if k==0 && k!=lengthS-1
						nameS <<" "+name
						next
					end
					if name.length > 5
						name=name.slice(0..4)+"."
					end
					nameS <<" "+name
				end
				pointsGrMCount << { sum:iikos['DishAmountInt'] , type: nameS }
                sum+=iikos['DishAmountInt']

			  end
		end

		pointsGrMCount = pointsGrMCount.sort_by { |h| -h[:sum]}
		laGrMCount<<{label:"Блюда",value:"Кол."}
		pointsGrMCount.each_with_index do |i,k|
			if k>19
				break
			end
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			laGrMCount<<{label:(k+1).to_s+". "+i[:type],value:str}

		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
        send_event('TopGruppMCount'+@name, { items: laGrMCount ,moreinfo:Date.today.strftime("%B"),sum:sum})
		#Топ блюд
        sum=0
		dataBludM = @dataIiko.IikoPostRequestForSebesMounth("PostBlud.json","CURRENT_MONTH")
		pointsBludM= []
		laBludM = []

		dataBludM['data'].each do |iikos|
            if iikos['DishName'].nil?
                next
            end
			  if iikos['DishName'].length < 20
				pointsBludM << { sum:iikos['DishAmountInt'] , type: iikos['DishName'] }
                sum+=iikos['DishAmountInt']
			  else
				nameS = ""
				lengthS = iikos['DishName'].split(" ").length
				i = 0
				iikos['DishName'].split(" ").each_with_index do |name,k|
					if k==lengthS-1
						next
					end
					if k==0
						nameS <<" "+name
						next
					end
					if name.length > 3
						name=name.slice(0..2)+"."
					end
					nameS <<" "+name
				end
				pointsBludM << { sum:iikos['DishAmountInt'] , type: nameS }
                sum+=iikos['DishAmountInt']

			  end
		end
		pointsBludM = pointsBludM.sort_by { |h| -h[:sum]}
		laBludM<<{label:"Блюда",value:"Кол."}
		pointsBludM.each_with_index do |i,k|

			if k>19
				break
			end
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			laBludM<<{label:(k+1).to_s+". "+i[:type],value:str}

		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
		send_event('TopBludM'+@name, { items:laBludM ,moreinfo:Date.today.strftime("%B"),sum:sum})

	end
	

	
end