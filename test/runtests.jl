using AnnotatedArrays

using Test

testsets = [
]

for testset in testsets
    try
        include(testset)
        printl("PASSED: $testset")
    catch e
        printl("FAILED: $testset")
        rethrow(e)
    end
end
