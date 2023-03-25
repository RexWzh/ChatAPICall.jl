using ChatAPICall
using Documenter

DocMeta.setdocmeta!(ChatAPICall, :DocTestSetup, :(using ChatAPICall); recursive=true)

makedocs(;
    modules=[ChatAPICall],
    authors="rex <1073853456@qq.com> and contributors",
    repo="https://github.com/RexWzh/ChatAPICall.jl/blob/{commit}{path}#{line}",
    sitename="ChatAPICall.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RexWzh.github.io/ChatAPICall.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RexWzh/ChatAPICall.jl",
    devbranch="main",
    devurl = "dev",
    versions = ["v#.#", "dev" => "dev", "stable" => "v^"],
)
