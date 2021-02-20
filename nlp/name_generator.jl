
function ngrams(text::AbstractString; n=2)
    str = '*'^n * text * '*'
    tokens = [(str[i:i+n-1], str[i+n]) for i in 1:length(str)-n]
    tokens
end

function fit(corpora::String; n=2)
    words = [strip(w) for w in split(corpora, '\n')]
    tokens = [ngrams(w, n=n) for w in words]
    model = Dict{AbstractString,Vector{Char}}()
    for (k, v) in vcat(tokens...)
        push!(get!(model, k, []), v) 
    end
    model
end

function test()
    corpora = "London \nNew York\nYorkshire"
    model = fit(corpora)
    print(model)
end