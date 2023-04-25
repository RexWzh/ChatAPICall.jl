@test !isempty(apikey) # apikey should be set

@testset "Test from README" begin
    chat = Chat("Hello, GPT-3.5!")
    resp = getresponse(chat; temperature=0.5, maxrequests=2)
    @test length(chat) == 1
    println("Number of consumed tokens: ", resp.total_tokens)
    println("Returned content: ", resp.content)
    @test true

    chat2 = Chat("Hello, GPT-3.5!")
    resp2 = getresponse!(chat2; temperature=0.5, top_p=0.5, maxrequests=3)
    @test length(chat2) == 2
    @test resp2.prompt_tokens == resp.prompt_tokens

    # invalid request
    chat4 = Chat("Hello, GPT-3.5!", "sk-test")
    @test_throws ArgumentError getresponse(chat4, maxrequests=2)

    tmpkey = apikey
    setapikey("sk-test")
    chat3 = Chat("Hello, GPT-3.5!")
    @test_throws ArgumentError getresponse(chat3, maxrequests=2)
    setapikey(tmpkey)
end