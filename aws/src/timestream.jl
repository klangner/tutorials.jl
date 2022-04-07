# using AWS.AWSServices: timestream_query, secrets_manager
using AWS: @service, generate_service_url, JSONService, global_aws_config
using AWS.UUIDs
using BenchmarkTools

@service Timestream_Query
@service Timestream_Write
@service S3



function init_client()
    ep_info = Timestream_Query.describe_endpoints()
    endpoints = first(ep_info)[2]
    a = endpoints[1]["Address"]
    uri = a[1:findfirst('.', a)] * "timestream"
    JSONService(
        "timestream", uri, "2018-11-01", "1.0", "Timestream_20181101"
    )
end

client = init_client()

q = """
SELECT f, s, measure_value::double as v
FROM "arencibia-stg"."raw_readings" 
WHERE time between ago(15d) and now() and f='ARS14002' and s='PDT_701_ALT' and measure_name='DDATA'
LIMIT 100000
"""

function query(client, q)
    client_token = string(uuid4())
    result = client("Query", Dict{String,Any}("QueryString" => q, "ClientToken" => client_token))
    rows = result["Rows"]
    while haskey(result, "NextToken")
        result = client("Query", Dict{String,Any}("QueryString" => q, "ClientToken" => client_token, "NextToken" => result["NextToken"]))
        rows = [rows; result["Rows"]]
    end

    rows
end

rows = query(client, q);
length(rows)

function print_rows(rows, N)
    for i in 1:min(N, length(rows))
        r = rows[i]["Data"]
        str = join([r[j]["ScalarValue"] for j in 1:length(r)], ", ")
        println(str)
    end
end

print_rows(rows, 10)

# Columns
str = join([result["ColumnInfo"][i]["Name"] for i in 1:length(result["ColumnInfo"])], ", ")
