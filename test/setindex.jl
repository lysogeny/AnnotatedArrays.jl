function dummyset() 
    mat = reshape(collect(1:6), 3, 2)' |> collect
    ann = (DataFrame(:value => 1:2), DataFrame(:value => 1:3))
    ids = (["A", "B"] , ["a", "b", "c"])
    A = AnnotatedArray(mat, ann, ids)
end

@testset "Numerical index" begin
    A = dummyset()
    A[1] = 5
    @test A[1] == 5
    A[1, 3] = 555
    @test A[1,3] == 555
end

@testset "String index" begin
    A = dummyset()
    A["A", "c"] = 555
    @test A[1,3] == 555
    A[["A", "B"], "c"] = [555, 777]
    @test A[:,3] == [555, 777]
    A[:, "c"] = [666, 999]
    @test A[:,3] == [666, 999]
end

