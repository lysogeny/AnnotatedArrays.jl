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

@testset "Dialect determining" begin
    @test AnnotatedArrays.determine_dialect("loom") == AnnotatedArrays.Loom
    @test AnnotatedArrays.determine_dialect("") == AnnotatedArrays.UnknownHDF5Dialect
    @test AnnotatedArrays.determine_dialect("blub") == AnnotatedArrays.UnknownHDF5Dialect
    # Invalid errors
    fid = h5open("small.loom", "r")
    @test_throws AnnotatedArrays.UnknownDialectError AnnotatedArray(AnnotatedArrays.HDF5Dialect, fid)
end


