"this is a string: \" \a \b"
'these are escaped: \n \\ \t \''
`these are not escaped: \n ' " \t`

# Comment

-2.43
1234

http_requests_total{environment=~"staging|testing|development", method!="GET"}

http_requests_total offset 5m

sum(http_requests_total{method="GET"}[10m] offset 5m)

up > bool 0

sum(http_requests_total) without (instance)

count_values("version", build_version)

topk(5, http_requests_total)

sum(
  instance_memory_limit_bytes - instance_memory_usage_bytes
) by (app, proc) / 1024 / 1024

topk(3, sum(rate(instance_cpu_time_ns[5m])) by (app, proc))

job:http_inprogress_requests:sum = sum(http_inprogress_requests) by (job)
