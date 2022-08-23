using AnnotatedArrays
using DataFrames

using Test

testsets = [
    "constructors.jl",
    "getindex.jl",
    "setindex.jl",
]

for testset in testsets
    try
        include(testset)
        println("PASSED: $testset")
    catch e
        println("FAILED: $testset")
        rethrow(e)
    end
end
