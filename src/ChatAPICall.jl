module ChatAPICall

using HTTP, JSON

export 
    # proxy
    proxy_on, proxy_off, proxy_status,
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
    apikey = nothing
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
    if apikey === nothing
        println("`apikey` is not set.")
    else
        println("apikey: ", apikey)
    end
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
    while maxrequests != 0
        try
            resp = request(chat.chatlog; model=model, options...)
            return Resp(JSON.parse(String(resp.body)), compact=compact)
        catch
            # TODO: Print error logs
            @warn "Invalid response from OpenAI API."
            maxrequests -= 1
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