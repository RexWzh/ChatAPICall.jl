@test !isnothing(apikey) # apikey should be set

@testset "Test from README" begin
    chat = Chat("Hello, GPT-3.5!")
    resp = getresponse(chat; temperature=0.5, maxrequests=-1)
    @test length(chat) == 1
    println("Number of consumed tokens: ", resp.total_tokens)
    println("Returned content: ", resp.content)
    @test true

    chat2 = Chat("Hello, GPT-3.5!")
    resp2 = getresponse!(chat2; temperature=0.5, top_p=0.5, maxrequests=3)
    @test length(chat2) == 2
    @test resp2.prompt_tokens == resp.prompt_tokens

    # invalid request
    chat3 = Chat("Hello, GPT-3.5!")
    setapikey("sk-test")
    @test_throws ArgumentError getresponse(chat3, maxrequests=3)
end