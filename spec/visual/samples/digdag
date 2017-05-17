timezone: UTC

+emr_cluster:
  emr>:
  cluster:
    name: my-emr-cluster
    ec2:
      key: my-ec2-key
      master_type: m3.2xlarge
      instances:
        type: m3.xlarge
        count: 3
    applications:
      - spark
      - hive
      - hue
    bootstrap:
      - ...
      - ...
    tags:
      foo: bar
  steps:
    - type: spark
      application: jars/foobar.jar
      args: [foo, the, bar]
      jars: lib/libfoo.jar
    - type: spark
      application: scripts/spark-test.py
      args: [foo, the, bar]
    - type: spark-sql
      query: queries/spark-query.sql
      result: s3://my-bucket/results/${session_uuid}/
    - type: hive
      script: hive/test.q
      vars:
        INPUT: s3://my-bucket/hive-input/
        OUTPUT: s3://my-bucket/hive-output/
      hiveconf:
        hive.support.sql11.reserved.keywords: false
    - type: command
      command: [echo, hello, world]
    - type: command
      command: [echo, hello, world]

+emr_steps:
  emr>:
  cluster: ${emr.last_cluster_id}
  steps:
    - type: spark
      application: jars/foobar.jar
      args: [foo, the, bar]
    - type: spark
      application: scripts/spark-test.py
      args: [foo, the, bar]
    - type: spark-sql
      query: queries/spark-query.sql
      result: s3://my-bucket/results/${session_uuid}/
    - type: command
      command: echo
      args: [hello, world]
    - type: script
      command: scripts/hello.sh
      args: [foo, bar]

