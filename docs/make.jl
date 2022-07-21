using Taichi
using Documenter

DocMeta.setdocmeta!(Taichi, :DocTestSetup, :(using Taichi); recursive=true)

makedocs(;
    modules=[Taichi],
    authors="Gabriel Wu <wuzihua@pku.edu.cn> and contributors",
    repo="https://github.com/lucifer1004/Taichi.jl/blob/{commit}{path}#{line}",
    sitename="Taichi.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://lucifer1004.github.io/Taichi.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/lucifer1004/Taichi.jl",
    devbranch="main",
)
