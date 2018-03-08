# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'sql.rb'

    class HQL < SQL
      title "HQL"
      desc "Hive Query Language SQL dialect"
      tag 'hql'
      filenames '*.hql'

      def self.keywords
        # source: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL
        @keywords ||= Set.new(%w(
          ADD ADMIN AFTER ANALYZE ARCHIVE ASC BEFORE BUCKET BUCKETS CASCADE
          CHANGE CLUSTER CLUSTERED CLUSTERSTATUS COLLECTION COLUMNS COMMENT
          COMPACT COMPACTIONS COMPUTE CONCATENATE CONTINUE DATA DATABASES
          DATETIME DAY DBPROPERTIES DEFERRED DEFINED DELIMITED DEPENDENCY DESC
          DIRECTORIES DIRECTORY DISABLE DISTRIBUTE ELEM_TYPE ENABLE ESCAPED
          EXCLUSIVE EXPLAIN EXPORT FIELDS FILE FILEFORMAT FIRST FORMAT FORMATTED
          FUNCTIONS HOLD_DDLTIME HOUR IDXPROPERTIES IGNORE INDEX INDEXES INPATH
          INPUTDRIVER INPUTFORMAT ITEMS JAR KEYS KEY_TYPE LIMIT LINES LOAD
          LOCATION LOCK LOCKS LOGICAL LONG MAPJOIN MATERIALIZED METADATA MINUS
          MINUTE MONTH MSCK NOSCAN NO_DROP OFFLINE OPTION OUTPUTDRIVER
          OUTPUTFORMAT OVERWRITE OWNER PARTITIONED PARTITIONS PLUS PRETTY
          PRINCIPALS PROTECTION PURGE READ READONLY REBUILD RECORDREADER
          RECORDWRITER REGEXP RELOAD RENAME REPAIR REPLACE REPLICATION RESTRICT
          REWRITE RLIKE ROLE ROLES SCHEMA SCHEMAS SECOND SEMI SERDE
          SERDEPROPERTIES SERVER SETS SHARED SHOW SHOW_DATABASE SKEWED SORT
          SORTED SSL STATISTICS STORED STREAMTABLE STRING STRUCT TABLES
          TBLPROPERTIES TEMPORARY TERMINATED TINYINT TOUCH TRANSACTIONS UNARCHIVE
          UNDO UNIONTYPE UNLOCK UNSET UNSIGNED URI USE UTC UTCTIMESTAMP
          VALUE_TYPE VIEW WHILE YEAR IF

          ALL ALTER AND ARRAY AS AUTHORIZATION BETWEEN BIGINT BINARY BOOLEAN
          BOTH BY CASE CAST CHAR COLUMN CONF CREATE CROSS CUBE CURRENT
          CURRENT_DATE CURRENT_TIMESTAMP CURSOR DATABASE DATE DECIMAL DELETE
          DESCRIBE DISTINCT DOUBLE DROP ELSE END EXCHANGE EXISTS EXTENDED
          EXTERNAL FALSE FETCH FLOAT FOLLOWING FOR FROM FULL FUNCTION GRANT
          GROUP GROUPING HAVING IF IMPORT IN INNER INSERT INT INTERSECT
          INTERVAL INTO IS JOIN LATERAL LEFT LESS LIKE LOCAL MACRO MAP MORE
          NONE NOT NULL OF ON OR ORDER OUT OUTER OVER PARTIALSCAN PARTITION
          PERCENT PRECEDING PRESERVE PROCEDURE RANGE READS REDUCE REVOKE RIGHT
          ROLLUP ROW ROWS SELECT SET SMALLINT TABLE TABLESAMPLE THEN TIMESTAMP
          TO TRANSFORM TRIGGER TRUE TRUNCATE UNBOUNDED UNION UNIQUEJOIN UPDATE
          USER USING UTC_TMESTAMP VALUES VARCHAR WHEN WHERE WINDOW WITH

          AUTOCOMMIT ISOLATION LEVEL OFFSET SNAPSHOT TRANSACTION WORK WRITE

          COMMIT ONLY REGEXP RLIKE ROLLBACK START

          ABORT KEY LAST NORELY NOVALIDATE NULLS RELY VALIDATE

          CACHE CONSTRAINT FOREIGN PRIMARY REFERENCES

          DETAIL DOW EXPRESSION OPERATOR QUARTER SUMMARY VECTORIZATION WEEK YEARS MONTHS WEEKS DAYS HOURS MINUTES SECONDS

          DAYOFWEEK EXTRACT FLOOR INTEGER PRECISION VIEWS

          TIMESTAMPTZ ZONE

          TIME NUMERIC
        ))
      end

      def self.keywords_type
        # source: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types
        @keywords_type ||= Set.new(%w(
            TINYINT SMALLINT INT INTEGER BIGINT FLOAT DOUBLE PRECISION DECIMAL NUMERIC
            TIMESTAMP DATE INTERVAL
            STRING VARCHAR CHAR
            BOOLEAN BINARY
            ARRAY MAP STRUCT UNIONTYPE
        ))
      end

      prepend :root do
        rule /\$\{/, Name::Variable, :hive_variable

        # The SQL class interprets this as Name::Variable; I'm not 100% sure that's
        # a bug, but it certainly doesn't agree with what it means in HQL. So I'm
        # overriding this to mean Str::Single here
        rule /"/, Str::Single, :double_string

        rule /\w[\w\d]*/ do |m|
          if self.class.keywords_type.include? m[0].upcase
            token Keyword::Type
          elsif self.class.keywords.include? m[0].upcase
            token Keyword
          else
            token Name
          end
        end
      end

      prepend :single_string do
        rule /\$\{/, Name::Variable, :hive_variable
        rule /[^\\'\$]+/, Str::Single
      end

      prepend :double_string do
        rule /\$\{/, Name::Variable, :hive_variable
        # override because SQL sees this as Name::Variable
        rule /"/, Str::Single, :pop!
        rule /[^\\"\$]+/, Str::Single
      end

      state :hive_variable do
        rule /\}/, Name::Variable, :pop!
        rule /[^\}]+/, Name::Variable
      end

    end
  end
end
