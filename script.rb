
# coding:utf-8
require 'mechanize'
require 'date'
require 'tor-privoxy'

puts Time.new
agent ||= TorPrivoxy::Agent.new '127.0.0.1', '', {8118 => 9050} do |agent|
	sleep 10
	puts "New IP is #{agent.ip}"
end

autoReserveationOn = false
autoReserveationOn = false if agent.ip == '133.27.246.233'

username = ''
password = ''
date = Date.today
errorText = 'Error'
success = false
# 授業名
# 体育システムをEnglish版に変更して、予約したい授業の名前をコピーしてください。
classname = 'Diet for Athlete'

# 木曜日まで日付を進める
date += 1 until date.wday == 4
# Dateオブジェクトをstrに
date = date.strftime('%Y%m%d')
date.delete!('-')

url = "pc.php?page=reserve&mode=select&d=#{date}&semesterHidden=20155&lang=en"

if autoReserveationOn == true
  # agent = Mechanize.new
  agent.user_agent_alias = 'Mac FireFox'
  agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

  agent.get('https://wellness.sfc.keio.ac.jp/v3/') do |page|
    page.encoding = 'utf-8'
    page = page.form_with(action: 'pc.php') do |form|
      form.field_with(name: 'login').value = username
      form.field_with(name: 'lang').value = 'en'
      form.field_with(name: 'password').value = password
    end.click_button

    page.body.force_encoding('utf-8').encode
    if page.body.include?('Login name or password is incorrect.')
      puts '- error: failed to login'
    elsif page.body.include?('Login success!')
      puts '- Login success!'

      page = page.link_with(text: ' Make Reservation').click
      pageTmp = page
      10.times do |i|
        puts "#{i}times"
        page = pageTmp
        hrefs = page.search('//a[contains( ./text() , "[Reserve]" )]/@href')
        links = []
        hrefs.each do |href|
          links.push(page.link_with(href: href.text))
        end
        links.each do |link|
          page = link.click
          puts 'Serching...'
          result = page.search("//td[contains( ./text() , '#{classname}' )]/following-sibling::td[5] ").text
          result = 'none' if result == ''
          unless result == '0' || result == 'none'
            puts 'find a available one'
            # get lecture number
            lectureHref =  page.search("//td[contains( ./text() , '#{classname}' )]/following-sibling::td[2]/a/@href")[0]
            lectureHrefStr = lectureHref.to_s
            lectureNumber = lectureHrefStr[/lecture=(.*)&semesterHidden/, 1]
            # puts "- #{classname}:#{lectureNumber}"

            # Reservation
            puts 'Reserving...'
            form = page.forms[1]
            form.radiobutton_with(value: lectureNumber).check
            page = form.submit

            if page.body.include?('You cannot reserve classes for soft course students only.')
              errorText = '- You cannot reserve classes for soft course students only.'
              puts '- You cannot reserve classes for soft course students only.'
            elsif page.body.include?('You have already reserved the class.')
              errorText =  '- You have already reserved the class.'
              puts '- You have already reserved the class.'
            elsif page.body.include?('Please check the syllabus and reserve the class.')
              form = page.forms[1]
              page = form.submit
              if page.body.include?('is reserved.')
                # `osascript -e 'display notification "Reservation Successes!"'`
                puts "Reservation Successes!"
                success = true
              else
                errorText = '- Error: Reservation faild.'
                puts '- Error: Reservation faild.'
              end
            end
          end
          sleep(rand(2))
        end # links.each end
        sleep(rand(20..40))
      end # times end
      if success
        # puts 'Reservation Success!'
      else
        # puts errorText
      end
    end # elsif end
  end
  time =  Time.new
  puts "END #{time}"
else
  puts '- autoReserveation Off'
  time =  Time.new
  puts "END #{time}"
end
