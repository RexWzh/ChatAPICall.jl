
@testset "proxy_on" begin
    url = "127.0.0.1:7890"
    proxy_on(url, url)
    @test ENV["HTTP_PROXY"] == url
    @test ENV["HTTPS_PROXY"] == url
end

@testset "proxy_off" begin
    proxy_off()
    @test !haskey(ENV, "HTTP_PROXY")
    @test !haskey(ENV, "HTTPS_PROXY")
end

@testset "proxy_status" begin
    url = "127.0.0.1:7890"
    proxy_on(url, url)
    @test ENV["HTTP_PROXY"] == url
    @test ENV["HTTPS_PROXY"] == url
    proxy_status()
    proxy_off()
    @test true

    showapikey()
    @test true
end