
request(chat::Chat; options...) = request(chat.apikey, chat.chatlog; options...)
function request(apikey::AbstractString, msg::AbstractVector{<:AbstractDict}; options...)
    isempty(apikey) && throw(ArgumentError("`apikey` is not set!"))
    # convert options to Dict
    options = Dict{String, Any}(string(key) => val for (key, val) in options)
    haskey(options, "model") || throw(ArgumentError("`model` is not set!"))
    headers = [
        "Content-Type" => "application/json",
        "Authorization" => "Bearer $apikey"
    ]
    options["messages"] = msg
    data = JSON.json(options)
    HTTP.post(
        "$base_url/v1/chat/completions",
        headers=headers,
        body=data
    )
end