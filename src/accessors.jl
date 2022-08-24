function data(A::AnnotatedArray{T, N}) where {T, N}
    A.dat
end
function data(A::AnnotatedArray{T, N}, index::Int) where {T, N}
    A.dat[index]
end
