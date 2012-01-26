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
			doc = Nokogiri::XML(fobj)

			#Search plurks you posted
			content = doc.xpath("//xmlns:div[@class='bigplurk']").inner_html.to_s
			m = content.match(/<a.*>(.+)<\/a>\s*(<span.*>.*<\/span>)?\s*(.*)\s*<div class="meta">([0-9\-\ :]+),*.*<\/div>\s*/m)
			original_author = m[1]
			content = m[3]
			datetime = m[4]
			@@plurks[fid] = [{:author=>original_author, :content=>content, :datetime=>datetime}]

			#Search its responses
			res = doc.xpath("//xmlns:div[@class='response']")
			res.each do |r|
				content = r.inner_html.to_s
				m = content.match(/<a.*>(.+)<\/a>\s*(<span.*>.*<\/span>)?\s*<span class=\"plurk_content\">(.*)<\/span>.*/m)
				responser = m[1]
				content = m[3]
				@@plurks[fid] << {:responser=>responser, :content=>content}
			end
		end
	end
end

def search(keyword)
	result = ''
	@@plurks.each do |key,data|
		#Search plurks you posted
		d = data[0]
		result += "<div class=\"result\">#{d[:author]}: #{d[:content]},#{d[:datetime]}</div>" if d[:content].match /#{keyword}/i

		#Search its responses
		data.each_index do |idx|
			unless idx==0
				d = data[idx]
				result += "<div class=\"result\">#{d[:responser]}: #{d[:content]}</div>" if d[:content]
				.match /#{keyword}/i
			end
		end
	end
	result
end

initial_structure