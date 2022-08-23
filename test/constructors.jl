@testset "Inner constructor" begin
    mat = zeros(Int, 3, 4)
    ann = (DataFrame(:value => 1:3), DataFrame(:value => 1:4))
    ids = (["A", "B", "C"], ["a", "b", "c", "d"])
    A = AnnotatedArray{Int, 2}(mat, ann, ids)
    @test typeof(A) <: AnnotatedArray{Int, 2}
end

@testset "Outer constructors" begin
    mat = zeros(Int, 3, 4)
    ann = (DataFrame(:value => 1:3), DataFrame(:value => 1:4))
    ids = (["A", "B", "C"], ["a", "b", "c", "d"])
    A3 = AnnotatedArray(mat, ann, ids)
    @test typeof(A3) <: AnnotatedArray{Int, 2}
    A2 = AnnotatedArray(mat, ann)
    @test typeof(A2) <: AnnotatedArray{Int, 2}
    A1 = AnnotatedArray(mat)
    @test typeof(A1) <: AnnotatedArray{Int, 2}
    @test A1.arr == A2.arr == A3.arr == mat
    @test size(A1.arr) == (3, 4)
    @test nrow.(A1.dat) == (3, 4)
    @test length.(A1.ids) == (3, 4)
end

@testset "Check constructor throws error on size mismatch " begin
    mat = zeros(Int, 3, 4)
    ann = (DataFrame(:value => 1:3), DataFrame(:value => 1:4))
    ann_short = (DataFrame(:value => 1:3), DataFrame(:value => 1:3))
    ids = (["A", "B", "C"], ["a", "b", "c", "d"])
    @test_throws DimensionMismatch AnnotatedArray(mat[2:2,2:2], ann, ids)
    @test_throws DimensionMismatch AnnotatedArray(mat, ann, (ids[1][1:2], ids[2]))
    @test_throws DimensionMismatch AnnotatedArray(mat, ann_short, ids)
end
