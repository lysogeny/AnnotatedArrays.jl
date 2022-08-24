using HDF5
using DataFrames

@testset "Getting data works" begin
    A = AnnotatedArray(h5open("small.loom", "r"))
    @test typeof(data(A)) <: NTuple{3, DataFrame}
    @test typeof(data(A, 1)) <: DataFrame
    @test_throws BoundsError data(A, 4)
end
@testset "Can set data" begin
    A = AnnotatedArray(h5open("small.loom", "r"))
    data(A, 1)[!,"lol"] .= true
    @test all(data(A, 1)[!, "lol"])
    # Setting on view
    Ai = A[1:2,:,"matrix"]
    data(Ai, 1)[:,"lmao"] .= [1, 2]
    @test data(A, 1)[1:2, "lmao"] == [1, 2]
    @test all(ismissing.(data(A, 1)[3:end, "lmao"]))
end
