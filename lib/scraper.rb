require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    extracted_page = Nokogiri::HTML(open(index_url))
    student_hash = {}
    student_hash_array = []

    student_cards = extracted_page.css(".student-card")

    student_cards.each do |student|
      student_hash = {
        name: student.css("h4").text,
        location: student.css("p").text,
        profile_url: "./fixtures/student-site/" + "#{student.css("a")[0]["href"]}"
      }
      student_hash_array << student_hash
    end
    student_hash_array
  end

  def self.scrape_profile_page(profile_url)
    extracted_page = Nokogiri::HTML(open(profile_url))
    profile_hash = {}

    social_details = extracted_page.css("div.social-icon-container a")

    social_details.each do |detail|
      website = detail.attribute("href").value
      case
        when website.include?("twitter.com")
          profile_hash[:twitter] = website
        when website.include?("linkedin.com")
          profile_hash[:linkedin] = website
        when website.include?("github.com")
          profile_hash[:github] = website
        when website.include?("facebook.com")
          profile_hash[:facebook] = website
        when website.include?("youtube.com")
          profile_hash[:youtube] = website       
        else
          profile_hash[:blog] = website
      end
    #  binding.pry
    end
    profile_hash[:profile_quote] = extracted_page.css("div.profile-quote").text
    profile_hash[:bio] = extracted_page.css("div.description-holder p").text
    profile_hash
  end

end
