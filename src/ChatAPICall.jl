module ChatAPICall

using HTTP, JSON

"""
    Chat

Chat with OpenAI API.

# Fields

- `chatlog::Vector{Dict}`: The chat log, default to be `Dict[]`.
- `apikey::String`: The API key, default to be `ChatAPICall.apikey`.
"""
Base.@kwdef mutable struct Chat
    chatlog::Vector{Dict}=Dict[]
    apikey::String=""
end

export 
    # proxy
    proxy_on, proxy_off, proxy_status,
    setbaseurl,
    # chat
    Chat, getresponse, getresponse!,
    defaultprompt, showapikey, setapikey,
    add!, adduser!, addsystem!, addassistant!,
    # resp
    Resp, ErrResp

# get api key
if !isnothing(get(ENV, "OPENAI_API_KEY", nothing))
    apikey = ENV["OPENAI_API_KEY"]
else
    apikey = ""
end

"""
    setapikey(key::AbstractString)

Set the OpenAI API key.
"""
function setapikey(key::AbstractString)
    global apikey = key
end

"""
    showapikey()

Show the OpenAI API key.
"""
function showapikey()
    if isempty(apikey)
        println("`apikey` is not set.")
    else
        println("apikey: ", apikey)
    end
end

base_url = "https://api.openai.com"

"""
    setbaseurl(url::AbstractString)

Set the proxy URL of the OpenAI API.
"""
function setbaseurl(url::AbstractString)
    global base_url = url
end

include("http.jl")
include("resp.jl")
include("proxy.jl")
include("chat.jl")

"""
    getresponse( chat::Chat
               , maxrequests::Int=1
               , compact::Bool=true
               , model::AbstractString="gpt-3.5-turbo"
               , options...)::Resp
    
Get a response from OpenAI API.

# Arguments

- `chat::Chat`: The chat log.
- `maxrequests::Int`: The maximum number of requests to OpenAI API.
- `compact::Bool`: Whether to compact the response.
- `model::AbstractString`: The model to use.
- `**options`: Other options to pass to `ChatAPICall.request`.
"""
function getresponse( chat::Chat
                    ; maxrequests::Int=1
                    , compact::Bool=true
                    , model::AbstractString="gpt-3.5-turbo"
                    , options...)::Resp
    numoftries = 0
    while maxrequests != 0
        try
            resp = request(chat; model=model, options...)
            return Resp(JSON.parse(String(resp.body)), compact=compact)
        catch y
            # TODO: Print error logs
            numoftries += 1
            maxrequests -= 1
            @warn "Failed attempt $numoftries: $y"
        end
    end
    throw(ArgumentError("Maximum number of requests reached"))
end

"""
    getresponse!( chat::Chat
                , maxrequests::Int=1
                , compact::Bool=true
                , model::AbstractString="gpt-3.5-turbo"
                , options...)::Resp

Get a response from OpenAI API and add it to the chat log.
"""
function getresponse!( chat::Chat
                     ; maxrequests::Int=1
                     , compact::Bool=true
                     , model::AbstractString="gpt-3.5-turbo"
                     , options...)::Resp
    resp = getresponse(chat; maxrequests=maxrequests, compact=compact, model=model, options...)
    add!(chat, resp)
    return resp 
end

end