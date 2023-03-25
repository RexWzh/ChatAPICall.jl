# Methods for the struct Chat
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
    add!(chat::Chat, role::AbstractString, content::AbstractString)

Add a message to the chat log.
"""
function add!(chat::Chat, role::AbstractString, content::AbstractString)
    role in ["user", "system", "assistant"] || throw(ArgumentError("role must be one of \"user\", \"system\", or \"assistant\""))
    push!(chat.chat_log, Dict("role" => role, "text" => content))
end

"""
    add!(chat::Chat, resp::Resp)

Add a response from OpenAI API to the chat log.

# Arguments

- `chat::Chat`: The chat log.
- `resp::Resp`: The response from OpenAI API.
"""
function add!(chat::Chat, resp::Resp)
    add!(chat, "system", resp.content)
end

"""
    adduser!(chat::Chat, content::AbstractString)

Add a user message to the chat log.
"""
function adduser!(chat::Chat, content::AbstractString)
    add!(chat, "user", content)
end

"""
    addsystem!(chat::Chat, content::AbstractString)

Add a system message to the chat log.
"""
function addsystem!(chat::Chat, content::AbstractString)
    add!(chat, "system", content)
end

"""
    addassistant!(chat::Chat, content::AbstractString)

Add an assistant message to the chat log.
"""
function addassistant!(chat::Chat, content::AbstractString)
    add!(chat, "assistant", content)
end

"""
    copy(chat::Chat)

Copy a chat log.
"""
Base.copy(chat::Chat) = Chat(copy(chat.chat_log))

"""
    pop!(chat::Chat)

Pop the last message from the chat log.
"""
Base.pop!(chat::Chat) = pop!(chat.chat_log)

"""
    length(chat::Chat)

Get the number of messages in the chat log.
"""
Base.length(chat::Chat) = length(chat.chat_log)

"""
    show(io::IO, chat::Chat)

Show information of the chat log.
"""
function Base.show(io::IO, chat::Chat)
    show(io, "<Chat with ", length(chat), " messages>")
end

"""
    print(io::IO, chat::Chat)

Print the chat log.
"""
function Base.print(io::IO, chat::Chat, sep::AbstractString)
    for msg in chat.chat_log
        print(io, sep, msg["role"], sep, msg["content"])
    end
end

"""
    print(io::IO, chat::Chat)

Print the chat log.
"""
Base.print(io::IO, chat::Chat) = print(io, chat, "\n" * "-" ^ 15 * "\n")
    
end