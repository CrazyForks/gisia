namespace :ci_database do
  desc 'Copy ci_builds from primary database to CI database and reset sequence'
  task copy_builds: :environment do
    primary_conn = ApplicationRecord.connection
    ci_conn = Ci::ApplicationRecord.connection

    column_names = ci_conn.columns(:ci_builds).map(&:name)
    quoted_columns = column_names.map { |c| primary_conn.quote_column_name(c) }
    column_list = quoted_columns.join(', ')
    total = primary_conn.execute('SELECT COUNT(*) FROM ci_builds').first['count'].to_i

    puts "Copying #{total} builds to CI database (skipping existing ids)..."

    offset = 0
    batch_size = 100
    loop do
      rows = primary_conn.execute("SELECT #{column_list} FROM ci_builds ORDER BY id LIMIT #{batch_size} OFFSET #{offset}")
      break if rows.ntuples == 0

      values_sql = rows.map do |row|
        "(#{column_names.map { |c| ci_conn.quote(row[c]) }.join(', ')})"
      end.join(', ')
      ci_conn.execute("INSERT INTO ci_builds (#{column_list}) VALUES #{values_sql} ON CONFLICT (id) DO NOTHING")
      offset += batch_size
    end

    max_id = ci_conn.execute('SELECT MAX(id) FROM ci_builds').first['max'].to_i
    ci_conn.execute("SELECT setval('ci_builds_id_seq', #{max_id + 1}, false)") if max_id > 0

    copied = ci_conn.execute('SELECT COUNT(*) FROM ci_builds').first['count']
    puts "Done. Copied #{copied} builds. Sequence reset to #{max_id + 1}."
  end
end
