
"""
    proxy_on(http::Union{Nothing, AbstractString}, https::Union{Nothing, AbstractString})

Turn on proxy.
"""
function proxy_on(http::Union{Nothing, AbstractString}, https::Union{Nothing, AbstractString})
    if !isnothing(http)
        ENV["HTTP_PROXY"] = http
    end
    if !isnothing(https)
        ENV["HTTPS_PROXY"] = https
    end
end

"""
    proxy_off()

Turn off proxy.
"""
function proxy_off()
    delete!(ENV, "HTTP_PROXY")
    delete!(ENV, "HTTPS_PROXY")
end

"""
    proxy_status()

Get proxy status.
"""
function proxy_status()
    if haskey(ENV, "HTTP_PROXY")
        println("HTTP_PROXY: ", ENV["HTTP_PROXY"])
    else
        println("HTTP_PROXY is not set.")
    end
    if haskey(ENV, "HTTPS_PROXY")
        println("HTTPS_PROXY: ", ENV["HTTPS_PROXY"])
    else
        println("HTTPS_PROXY: is not set.")
    end
end

