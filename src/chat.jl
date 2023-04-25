# Methods for the struct Chat
"""
    defaultprompt(msg)

Default prompt for `Chat(msg:AbstractString)`.
"""
defaultprompt(msg) = nothing

"""
    Chat(msg)

Initialize Chat object by a message.

By default, the `apikey` is set to be `ChatAPICall.apikey`.
"""
function Chat(msg::AbstractString, apikey::AbstractString)
    # initialize chat log by defaultprompt
    chatlog = defaultprompt(msg)
    # if msg is nothing, initialize chat log by a general prompt
    if isnothing(chatlog)
        chatlog = [Dict("role" => "user", "content" => msg),]
    end
    Chat(chatlog, apikey)
end
Chat(msg::AbstractString) = Chat(msg, ChatAPICall.apikey)
Chat(chatlog::AbstractVector{<:AbstractDict}) = Chat(chatlog, ChatAPICall.apikey)

"""
    add!(chat::Chat, role::AbstractString, content::AbstractString)

Add a message to the chat log.
"""
function add!(chat::Chat, role::AbstractString, content::AbstractString)
    role in ["user", "system", "assistant"] || throw(ArgumentError("role must be one of \"user\", \"system\", or \"assistant\""))
    push!(chat.chatlog, Dict("role" => role, "content" => content))
end

"""
    add!(chat::Chat, resp::Resp)

Add a response from OpenAI API to the chat log.

# Arguments

- `chat::Chat`: The chat log.
- `resp::Resp`: The response from OpenAI API.
"""
function add!(chat::Chat, resp::Resp)
    add!(chat, "assistant", resp.content)
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
Base.copy(chat::Chat) = Chat(copy(chat.chatlog), chat.apikey)

"""
    pop!(chat::Chat)

Pop the last message from the chat log.
"""
Base.pop!(chat::Chat) = pop!(chat.chatlog)

"""
    length(chat::Chat)

Get the number of messages in the chat log.
"""
Base.length(chat::Chat) = length(chat.chatlog)

"""
    show(io::IO, chat::Chat)

Show information of the chat log.
"""
function Base.show(io::IO, chat::Chat)
    print(io, "< Chat object with ", length(chat), " message(s) >")
end

"""
    print(io::IO, chat::Chat)

Print the chat log.
"""
function Base.print(io::IO, chat::Chat, sep::AbstractString)
    for msg in chat.chatlog
        println(io, sep, msg["role"], sep, msg["content"])
    end
end

"""
    print(io::IO, chat::Chat)

Print the chat log.
"""
Base.print(io::IO, chat::Chat) = print(io, chat, "\n" * "-" ^ 15 * "\n")
