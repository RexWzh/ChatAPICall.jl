module ChatAPICall

using HTTP, JSON

export 
    # proxy
    proxy_on, proxy_off, proxy_status,
    # chat
    Chat, getresponse, defaultprompt,
    add!, adduser!, addsystem!, addassistant!,
    # resp
    Resp, ErrResp

# get api key
if !isnothing(get(ENV, "OPENAI_API_KEY", nothing))
    api_key = ENV["OPENAI_API_KEY"]
else
    api_key = nothing
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
                    , maxrequests::Int=1
                    , compact::Bool=true
                    , model::AbstractString="gpt-3.5-turbo"
                    , options...)::Resp
    while maxrequests != 0
        resp = request(chat.chatlog, model=model, options...)
        if resp.status == 200
            return Resp(JSON.parse(String(resp.body)), compact=compact)
        else
            nothing # TODO: handle error
        end
        maxrequests -= 1
    end
    throw(ArgumentError("Maximum number of requests reached"))
end 

end