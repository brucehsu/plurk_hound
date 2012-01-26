require 'rubygems'
require 'nokogiri'
require 'json'

def search(keyword)
	plurks = Dir.new('plurks')
	result = ''
	plurks.each do |f|
		if f.end_with? '.html' 
			fobj = File.open(File.join(plurks.path, f))
			doc = Nokogiri::XML(fobj)

			#Search plurks you posted
			content = doc.xpath("//xmlns:div[@class='bigplurk']").inner_html.to_s
			m = content.match(/<a.*>(.+)<\/a>\s*(<span.*>.*<\/span>)?\s*(.*)\s*<div class="meta">([0-9\-\ :]+),*.*<\/div>\s*/m)
			original_author = m[1]
			content = m[3]
			datetime = m[4]
			result += "#{original_author}: #{content},#{datetime}<br />" if content.include? keyword

			#Search its responses
			res = doc.xpath("//xmlns:div[@class='response']")
			res.each do |r|
				content = r.inner_html.to_s
				m = content.match(/<a.*>(.+)<\/a>\s*(<span.*>.*<\/span>)?\s*<span class=\"plurk_content\">(.*)<\/span>.*/m)
				responser = m[1]
				content = m[3]
				result += "#{responser}: #{content}<br />" if content.include? keyword
			end
		end
	end
	result
end
