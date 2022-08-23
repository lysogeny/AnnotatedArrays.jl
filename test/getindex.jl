
mat = reshape(collect(1:6), 3, 2)' |> collect
ann = (DataFrame(:value => 1:2), DataFrame(:value => 1:3))
ids = (["A", "B"] , ["a", "b", "c"])
A = AnnotatedArray(mat, ann, ids)


@testset "Object has size" begin
    @test size(A) == (2, 3)
end

@testset "Test boring getindex" begin
    @test A[1] == 1
    @test A[6] == 6
    @test A[:] == [1, 4, 2, 5, 3, 6]
    @test A[1, 1] == 1
    @test A[2, 3] == 6
end

@testset "Getting indices in vector" begin
    v = ["A", "B", "C", "D"]
    @test indices(v, "A") == 1
    @test indices(v, "B") == 2
    @test indices(v, ["A", "B"]) == [1, 2]
    @test indices(v, ["A", 3]) == [1, 3]
    @test indices(v, [1, 2]) == [1, 2]
    @test indices(v, 1) == 1
end

@testset "Test dimension preserving numerical getindex" begin
    # Should keep type
    # [1:2,[1]]
    @test A[1:2,[1]].arr == A.arr[1:2,[1]]
    @test A[1:2,[1]].ids == (["A", "B"], ["a"])
    @test A[1:2,[1]].dat[1][!,:value] == [1, 2]
    @test A[1:2,[1]].dat[2][!,:value] == [1]
    @test typeof(A[1:2,[1]]) <: typeof(A)
    # [[1], 1:2]
    @test A[[1],1:2].arr == [1 2]
    @test A[[1],1:2].ids == (["A"], ["a", "b"])
    @test typeof(A[[1],1:2]) <: typeof(A)
    # [:, 1:2]
    @test typeof(A[:,:]) <: typeof(A)
end

@testset "Test dimension reducing numerical getindex" begin
    # Should drop to AnnotatedVector (which is a really dumb type)
    @test typeof(A[1:2, 1]) <: AnnotatedVector
    @test typeof(A[1, 1:2]) <: AnnotatedVector
    @test A[1:2, 1].dat[1][:,:value] == [1,2]
    @test A[1:2, 1].ids[1] == ["A", "B"]
    @test A[1:2, 1] == [1, 4]
    @test A[2, 1:3] == [4, 5, 6]
end

@testset "Test dimension preserving string getindex" begin
    # Should keep type
    # [1:2,[1]]
    @test A[1:2,["a"]].arr == A.arr[1:2,[1]]
    @test A[["A", "B"],["a"]].arr == A.arr[1:2,[1]]
    @test A[["B"],["a"]].arr == A.arr[[2],[1]]
end

@testset "Test dimension reducing string getindex" begin
    # Should drop axis
    # [1:2,[1]]
    @test A[1:2,"a"].arr == A.arr[1:2]
    @test typeof(A[1:2,"a"]) <: AnnotatedVector
end

