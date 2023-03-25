module OpenAICall

using OpenAI

# get api key
if !isnothing(get(ENV, "OPENAI_API_KEY", nothing))
    api_key = ENV["OPENAI_API_KEY"]
else
    api_key = nothing
end


include("resp.jl")
include("proxy.jl")
include("chat.jl")

"""
    getresponse( chat::Chat
               , maxrequests::Int=1
               , compact::Bool=true
               , model::AbstractString="gpt-3.5-turbo"
               , **options)::Resp
    
Get a response from OpenAI API.

# Arguments

- `chat::Chat`: The chat log.
- `maxrequests::Int`: The maximum number of requests to OpenAI API.
- `compact::Bool`: Whether to compact the response.
- `model::AbstractString`: The model to use.
- `**options`: Other options to pass to `OpenAICall.request`.
"""
getresponse() = nothing

end
