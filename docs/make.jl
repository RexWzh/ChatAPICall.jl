using OpenAICall
using Documenter

DocMeta.setdocmeta!(OpenAICall, :DocTestSetup, :(using OpenAICall); recursive=true)

makedocs(;
    modules=[OpenAICall],
    authors="rex <1073853456@qq.com> and contributors",
    repo="https://github.com/RexWzh/OpenAICall.jl/blob/{commit}{path}#{line}",
    sitename="OpenAICall.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RexWzh.github.io/OpenAICall.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RexWzh/OpenAICall.jl",
    devbranch="main",
)
