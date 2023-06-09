
@testset "Chat" begin
    chat = Chat()
    @test chat.chatlog == Dict[]

    msg = "Hello, world!"
    chat = Chat(msg)
    @test chat.chatlog == [
        Dict("role" => "user", "content" => msg),
    ]
    # use default prompt
    ChatAPICall.defaultprompt(msg) = [
        Dict("role" => "system", "content" => "You are a helpful assistant."),
        Dict("role" => "user", "content" => msg),
        ]
    chat = Chat(msg)
    @test chat.chatlog == [
        Dict("role" => "system", "content" => "You are a helpful assistant."),
        Dict("role" => "user", "content" => msg),
    ]
    # reset prompt
    ChatAPICall.defaultprompt(msg) = nothing
    chat = Chat(msg)
    @test chat.chatlog == [
        Dict("role" => "user", "content" => msg),
    ]
end

@testset "add" begin
    chat = Chat()
    add!(chat, "user", "Hello, world!")
    @test chat.chatlog == [
        Dict("role" => "user", "content" => "Hello, world!"),
    ]

    chat = Chat()
    resp = Resp(valid_response)
    add!(chat, resp)
    @test chat.chatlog == [
        Dict("role" => "assistant", "content" => "Hello, how can I assist you today?"),
    ]

    chat = Chat()
    adduser!(chat, "Hello, world!")
    @test chat.chatlog == [
        Dict("role" => "user", "content" => "Hello, world!"),
    ]

    chat = Chat()
    addsystem!(chat, "Hello, world!")
    @test chat.chatlog == [
        Dict("role" => "system", "content" => "Hello, world!"),
    ]

    chat = Chat()
    addassistant!(chat, "Hello, world!")
    @test chat.chatlog == [
        Dict("role" => "assistant", "content" => "Hello, world!"),
    ]
end

@testset "long chat" begin
    chat = Chat()
    addsystem!(chat, "Hello, world!")
    adduser!(chat, "Hello, world!")
    addassistant!(chat, "Hello, how can I assist you today?")
    adduser!(chat, "I want to know about the weather.")
    addassistant!(chat, "The weather is nice today.")

    @test chat.chatlog == [
        Dict("role" => "system", "content" => "Hello, world!"),
        Dict("role" => "user", "content" => "Hello, world!"),
        Dict("role" => "assistant", "content" => "Hello, how can I assist you today?"),
        Dict("role" => "user", "content" => "I want to know about the weather."),
        Dict("role" => "assistant", "content" => "The weather is nice today."),
    ]
end

@testset "copy, pop!, length" begin
    chat = Chat()
    chat2 = copy(chat)
    @test chat2.chatlog == chat.chatlog
    @test chat2.chatlog !== chat.chatlog

    chat = Chat()
    adduser!(chat, "Hello, world!")
    pop!(chat)
    @test chat.chatlog == Dict[]

    chat = Chat()
    @test length(chat) == 0
    adduser!(chat, "Hello, world!")
    @test length(chat) == 1

    ## long talk
    chat = Chat()
    addsystem!(chat, "Hello, world!")
    adduser!(chat, "Hello, world!")
    addassistant!(chat, "Hello, how can I assist you today?")
    adduser!(chat, "I want to know about the weather.")
    addassistant!(chat, "The weather is nice today.")
    @test length(chat) == 5
    pop!(chat)
    @test length(chat) == 4
    pop!(chat)
    @test length(chat) == 3
    pop!(chat)
    @test length(chat) == 2
    newchat = copy(chat)
    @test length(newchat) == 2
    pop!(chat)
    @test length(chat) == 1
    @test length(newchat) == 2
    pop!(chat)
    @test length(chat) == 0
    @test length(newchat) == 2
end

@testset "show(io::IO, chat::Chat)" begin
    chat = Chat()
    @test sprint(show, chat) == "< Chat object with 0 message(s) >"
    adduser!(chat, "Hello, world!")
    @test sprint(show, chat) == "< Chat object with 1 message(s) >"

    chat = Chat()
    @test sprint(print, chat) == ""
    adduser!(chat, "Hello, world!")
    sep = "\n" * "-" ^ 15 * "\n"
    @test sprint(print, chat) == "$(sep)user$(sep)Hello, world!\n"
end


@testset "Resp" begin
    resp = Resp(valid_response)
    @test resp.total_tokens == 18
    @test resp.prompt_tokens == 8
    @test resp.completion_tokens == 10
    @test resp.content == "Hello, how can I assist you today?"
    @test resp.id == "chatcmpl-6wXDUIbYzNkmqSF9UnjPuKLP1hHls"
    @test resp.model == "gpt-3.5-turbo-0301"

    resp = Resp(valid_response, compact=false)
    @test resp.content == "Hello, how can I assist you today?"
end