namespace :util do
    desc 'Resets Postgres auto-increment ID column sequences to fix duplicate ID errors'
    task :reset_sequences => :environment do
        Rails.application.eager_load!

        ActiveRecord::Base.descendants.each do |model|
            unless model.attribute_names.include?('id')
                Rails.logger.debug "Not resetting #{model}, which lacks an ID column"
                next
            end

            begin
                max_id = model.maximum(:id).to_i + 1
                result = ActiveRecord::Base.connection.execute(
                    "ALTER SEQUENCE #{model.table_name}_id_seq RESTART #{max_id};"
                )
                Rails.logger.info "Reset #{model} sequence to #{max_id}"
            rescue => e
                Rails.logger.error "Error resetting #{model} sequence: #{e.class.name}/#{e.message}"
            end
        end
    end
end
