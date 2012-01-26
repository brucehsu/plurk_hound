require 'rubygems'
require 'nokogiri'

def initial_structure
	@@plurks = {}
	plurks = Dir.new('plurks')
	result = ''
	plurks.each do |f|
		if f.end_with? '.html' 
			fobj = File.open(File.join(plurks.path, f))
			fid = f[0..5]
			doc = Nokogiri::HTML(fobj)

			#Search plurks you posted
			bigplurk = doc.xpath("//div[@class='bigplurk']")[0].elements
			excluded = Nokogiri::XML::NodeSet.new doc
			original_author = bigplurk[0].text
			excluded << bigplurk[0]
			datetime = bigplurk.xpath("//div[@class='meta']").text.match('[0-9\-\ :]+')[0]
			excluded << bigplurk.xpath("//div[@class='meta']")[0]
			qualifier = ''
			if bigplurk[1].name=='span' and bigplurk[1].attribute('class').value.match('qualifier')
				qualifier = bigplurk[1].text
				excluded << bigplurk[1]
			end
			content = (doc.xpath("//div[@class='bigplurk']")[0].children - excluded).to_html.strip
			@@plurks[fid] = [{:author=>original_author, :content=>content, :datetime=>datetime, :qualifier=>qualifier}]

			#Search its responses
			res = doc.xpath("//div[@class='response']")
			res.each do |r|
				r = r.elements
				responser = r[0].text
				qualifier = ''
				if r[1].name=='span' and r[1].attribute('class').value.match('qualifier')
					qualifier = r[1].text
				end
				content = ''
				r.each do |ele|
					if ele.name=='span' and ele.attribute('class').value=='plurk_content'
						content = ele.inner_html 
					end
				end
				@@plurks[fid] << {:responser=>responser, :content=>content, :qualifier=>qualifier}
			end
		end
	end
end

def search(keyword)
	result = ''
	@@plurks.each do |key,data|
		#Search plurks you posted
		d = data[0]
		result += "<div class=\"result\">#{d[:author]} #{d[:qualifier]}: #{d[:content]},#{d[:datetime]}</div>" if d[:content].match /#{keyword}/i

		#Search its responses
		data.each_index do |idx|
			unless idx==0
				d = data[idx]
				result += "<div class=\"result\">#{d[:responser]} #{d[:qualifier]}: #{d[:content]}</div>" if d[:content].match /#{keyword}/i
			end
		end
	end
	result
end

initial_structure