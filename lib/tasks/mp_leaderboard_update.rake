desc "update MP leaderboard after each new set of results"
task update_mp_leaderboard: :environment do
  date = Date.today
  # date = Date.parse("12 September 2026")

  log_file = Rails.root.join("log", "mp_leaderboard_update_#{date}.log")

  Mp.transaction do # will rollback on failure, but original use was for testing without committing changes to the database
    File.open(log_file, "a") do |log|
      Mp.find_each do |mp|
        name = mp.name
        agegroup_name = mp.agegroup
        agegroup = Agegroup.find_by(name: agegroup_name)
        next_agegroup_name = agegroup.next.name
        old_runs = mp.runs
        new_runs = old_runs + 1

        runs_found = Run.where(
          date: date,
          name: name,
          agegroup: [ agegroup_name, next_agegroup_name ],
          runs: new_runs
        )

        next unless runs_found.any?

        run = runs_found.first

        old_pb = mp.pb
        old_date = mp.date
        old_venue = mp.venue

        if run.time < mp.pb
          new_pb = run.time
          new_date = date
          new_venue = run.venue
          new_agegroup_name = run.agegroup
        else
          new_pb = mp.pb
          new_date = mp.date
          new_venue = mp.venue
          new_agegroup_name = agegroup_name
        end

        changes = []

        changes << "runs: #{old_runs} -> #{new_runs}" if old_runs != new_runs
        changes << "agegroup: #{agegroup_name} -> #{new_agegroup_name}" if agegroup_name != new_agegroup_name
        if new_pb < old_pb
          changes << "pb: #{old_pb} -> #{new_pb}"
          changes << "date: #{old_date} -> #{new_date}"
          changes << "venue: #{old_venue} -> #{new_venue}"
        end


        notes = []
        notes << "MULTIPLE RUNS: #{runs_found.count}" if runs_found.count > 1
        notes << "AGEGROUP CHANGE: #{agegroup_name} -> #{new_agegroup_name}" if new_agegroup_name != agegroup_name

        next if changes.empty? && notes.empty?

        log.puts(
          "#{Time.current} | #{name} | " \
          "#{(changes + notes).join(' | ')}"
        )

        mp.update!(
          runs: new_runs,
          pb: new_pb,
          date: new_date,
          venue: new_venue,
          agegroup: new_agegroup_name
        )
      end
    end
    # raise ActiveRecord::Rollback # useful for testing without committing changes to the database
  end
end
