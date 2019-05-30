# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Jsonnet do
  let(:subject) { Rouge::Lexers::JSON.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.json'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/json'
      assert_guess :mimetype => 'application/vnd.api+json'
      assert_guess :mimetype => 'application/hal+json'
    end

    it 'guesses by source' do
      assert_guess :mimetype => 'application/json', :source => <<-eos
      
      {"name": "value"}

eos
      assert_guess :mimetype => 'application/json',:source => <<-eos
      {
        "statement": "SELECT (CASE\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\"))=0 THEN NULL\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\"))=(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'skipped') THEN 'skipped'\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\"))=(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'success')+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"allow_failure\" = 't' AND \"ci_builds\".\"status\" IN ('failed', 'canceled'))+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'skipped') THEN 'success'\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\"))=(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'pending')+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'skipped') THEN 'pending'\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\"))=(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'canceled')+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'success')+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"allow_failure\" = 't' AND \"ci_builds\".\"status\" IN ('failed', 'canceled'))+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'skipped') THEN 'canceled'\n        WHEN (SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'running')+(SELECT count(*) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = 77 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\") AND \"ci_builds\".\"status\" = 'pending')>0 THEN 'running'\n        ELSE 'failed'\n      END) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = $1 AND \"ci_builds\".\"id\" IN (SELECT max(\"ci_builds\".id) FROM \"ci_builds\" WHERE \"ci_builds\".\"commit_id\" = $2 GROUP BY \"ci_builds\".\"name\", \"ci_builds\".\"commit_id\")"
      }
eos
    end
  end
end
