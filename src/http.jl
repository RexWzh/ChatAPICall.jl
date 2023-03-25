
function request(msg::AbstractVector{<:AbstractDict}; options...)
    api_key === nothing && throw(ArgumentError("`api_key` is not set!"))
    options = Dict{String, Any}(string(key) => string(val) for (key, val) in options)
    haskey(options, "model") || throw(ArgumentError("`model` is not set!"))
    headers = [
        "Content-Type" => "application/json",
        "Authorization" => "Bearer $api_key"
    ]
    options["messages"] = msg
    data = JSON.json(options)
    HTTP.post(
        "https://api.openai.com/v1/chat/completions",
        headers=headers,
        body=data
    )
end