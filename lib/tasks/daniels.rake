desc "discover faster daniels"
task get_daniels: :environment do
  name1="Daniel"
  name2="Dan"
  name3="Danny"
  agegroup="VM50-54"
  date = Date.parse("22 August 2026")
  time= "22:03"
  time_inseconds = Utility::TimeParser.parse_time_to_seconds(time)

  daniel_count = Run.where(date:, agegroup:).where("time<?", time_inseconds).where(
  "name ILIKE ? OR name ILIKE ? OR name ILIKE ?",
  "#{name1}%",
  "#{name2}%",
  "#{name3}%").size

  puts "There are #{daniel_count} Daniels in the #{agegroup} agegroup with a time under #{time}"
end
