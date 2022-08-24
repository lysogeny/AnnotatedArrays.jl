using HDF5
using DataFrames

@testset "File can load" begin 
    fid = h5open("small.loom", "r")
    A = AnnotatedArray(fid)
    @test typeof(A) <: AnnotatedArray
    @test size(A) == (10, 14, 4)
    @test size(A[:,:,"matrix"]) == (10, 14)
    @test ncol.(A.dat) == (6, 6, 2)
end


