module OpenAICall

using OpenAI

"""
    Chat

Chat with OpenAI API.

# Fields

- `chat_log::Vector{Dict}`: The chat log.
"""
struct Chat
    chat_log::Vector{Dict}
end
Chat() = Chat(Dict[])

"""
    defaultprompt(msg::AbstractString)

Default prompt for `Chat(msg:AbstractString)`.
"""
defaultprompt(msg::AbstractString) = [
    Dict("role" => "user", "text" => msg),
]
Chat(msg::AbstractString) = Chat(defaultprompt(msg))

"""
    Resp

Response from OpenAI API.

# Fields

- `total_tokens::Int`: Total number of tokens in the response.
- `prompt_tokens::Int`: Number of tokens in the prompt.
- `completion_tokens::Int`: Number of tokens in the completion.
- `content::String`: The completion.
- `id::String`: The ID of the completion.
- `model::String`: The model used to generate the completion.
"""
struct Resp
    total_tokens::Int
    prompt_tokens::Int
    completion_tokens::Int
    content::String
    id::String
    model::String
end

function Resp(response::Dict, compact::Bool=true)
    content = response["choices"][1]["message"]["content"]
    if compact
        content = strip(content)
    end
    return Resp(
        response["usage"]["total_tokens"],
        response["usage"]["prompt_tokens"],
        response["usage"]["completion_tokens"],
        content,
        response["id"],
        response["model"],
    )
end


include("proxy.jl")
include("chat.jl")


end
