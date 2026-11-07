# frozen_string_literal: true

CI.run do
  step 'Setup test environment', 'bin/setup --skip-server'
  step 'Style: Ruby', 'bin/rubocop'
  step 'Security: Gem audit', 'bin/bundler-audit check --update'
  step 'Security: Importmap audit', 'bin/importmap audit'
  step 'Security: Brakeman', 'bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error'
  step 'Autoloading', 'bin/rails zeitwerk:check'
  step 'Tests: Rails', 'bin/rails test'
  step 'Tests: System', 'bin/rails test:system' if CI_OPTIONS[:system]
end
