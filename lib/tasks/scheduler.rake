desc "This task will check vaccine slot availability"
task :check_vaccine_slot_availability => :environment do
  puts "Checking Slot"
  SlotCheck.run
  puts "done."
end

