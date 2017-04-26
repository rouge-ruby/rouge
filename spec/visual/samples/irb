irb(main):001:0> puts <<XYZ
irb(main):002:0" a
irb(main):003:0" b
irb(main):004:0" XYZ
a
b
=> nil
irb(main):005:0> 



[1] pry(main)> o = Object.new
=> #<Object:0x0056182cb182b8>
[2] pry(main)> o.instance_variable_set(:@foo, Object.new); o
=> #<Object:0x0056182cb182b8 @foo=#<Object:0x0056182cb63100>>
[3] pry(main)> o.instance_variable_get(:@foo).instance_variable_set(:@bar, 3)
=> 3
[4] pry(main)> o
=> #<Object:0x0056182cb182b8 @foo=#<Object:0x0056182cb63100 @bar=3>>
[5] pry(main)> 

irb(main):001:0> puts "Hello, world!"; 3
Hello, world!
=> 3

[1] pry(main)> User
=> User(id: integer, email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: string, last_sign_in_ip: string, created_at: datetime, updated_at: datetime, name: string, admin: boolean, projects_limit: integer, skype: string, linkedin: string, twitter: string, authentication_token: string, bio: string, failed_attempts: integer, locked_at: datetime, username: string, can_create_group: boolean, can_create_team: boolean, state: string, color_scheme_id: integer, password_expires_at: datetime, created_by_id: integer, last_credential_check_at: datetime, avatar: string, confirmation_token: string, confirmed_at: datetime, confirmation_sent_at: datetime, unconfirmed_email: string, hide_no_ssh_key: boolean, website_url: string, notification_email: string, hide_no_password: boolean, password_automatically_set: boolean, location: string, encrypted_otp_secret: string, encrypted_otp_secret_iv: string, encrypted_otp_secret_salt: string, otp_required_for_login: boolean, otp_backup_codes: text, public_email: string, dashboard: integer, project_view: integer, consumed_timestep: integer, layout: integer, hide_project_limit: boolean, unlock_token: string, otp_grace_period_started_at: datetime, ldap_email: boolean, external: boolean, incoming_email_token: string, organization: string, authorized_projects_populated: boolean, ghost: boolean, last_activity_on: date, notified_of_own_activity: boolean, require_two_factor_authentication_from_group: boolean, two_factor_grace_period: integer)

[2] pry(main)> User.new
  ActiveRecord::SchemaMigration Load (0.3ms)  SELECT "schema_migrations".* FROM "schema_migrations"
  ActiveRecord::SchemaMigration Load (0.3ms)  SELECT "schema_migrations".* FROM "schema_migrations"
=> #<User id: nil, email: "", created_at: nil, updated_at: nil, name: nil, admin: false, projects_limit: 100000, skype: "", linkedin: "", twitter: "", authentication_token: nil, bio: nil, username: nil, can_create_group: true, can_create_team: false, state: "active", color_scheme_id: 1, password_expires_at: nil, created_by_id: nil, last_credential_check_at: nil, avatar: nil, hide_no_ssh_key: false, website_url: "", notification_email: nil, hide_no_password: false, password_automatically_set: false, location: nil, encrypted_otp_secret: nil, encrypted_otp_secret_iv: nil, encrypted_otp_secret_salt: nil, otp_required_for_login: false, otp_backup_codes: nil, public_email: "", dashboard: 0, project_view: 2, consumed_timestep: nil, layout: 0, hide_project_limit: false, otp_grace_period_started_at: nil, ldap_email: false, external: false, incoming_email_token: nil, organization: nil, authorized_projects_populated: nil, ghost: nil, last_activity_on: nil, notified_of_own_activity: false, require_two_factor_authentication_from_group: false, two_factor_grace_period: 48>

[5] pry(main)> raise 'hello'
RuntimeError: hello
from (pry):5:in `__pry__'
[6] pry(main)> puts 'hello'
hello
