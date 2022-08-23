# arr dat ids
Base.size(A::AnnotatedArray) = size(A.arr)

Base.getindex(A::AnnotatedArray{T, N}, i::Int) where {T, N} = getindex(A.arr, i)
Base.getindex(A::AnnotatedArray{T, N}, I::Vararg{Int, N}) where {T, N} = getindex(A.arr, I...)

Base.IndexStyle(A::AnnotatedArray{T, N}) where {T, N} = IndexStyle(A.arr)

Base.getindex(A::AnnotatedArray{T, N}, ::Colon) where {T, N} = A.arr[:]

Base.getindex(A::AnnotatedArray{T, N}, i::CartesianIndex) where {T, N} = A.arr[i]

function Base.getindex(A::AnnotatedArray{T, N}, I::Vararg{Any, N}) where {T, N} 
    annotatedgetindex(A, map((d, i) -> indices(d, i), A.ids, I)...)
end
#Base.getindex(A::AnnotatedArray{T, N}, i::AbstractArray) where {T, N} =  

indices(ids::AbstractVector{String}, c::Colon) = c
indices(ids::AbstractVector{String}, i::Int) = i
indices(ids::AbstractVector{String}, i::String) = findfirst(map(x -> x == i, ids))
indices(ids::AbstractVector{String}, i::AbstractVector) = map(x -> indices(ids, x), i)


keepingtype(x) = false
keepingtype(x::AbstractArray) = true
keepingtype(x::AbstractRange) = true
keepingtype(x::BitArray) = true
keepingtype(x::Colon) = true

# preserves dimensions
# annotatedgetindex(A, [1], [1])
function annotatedgetindex(A::S, index::Vararg{Union{AbstractVector{Int}, Colon, Int}, N}) where {T, N, S <: AnnotatedArray{T, N}}
    arr = view(A.arr, index...)

    DN = length(index)
    keepdims = filter(i -> keepingtype(index[i]), 1:DN)

    dat = map((x, i) -> view(x, i, :), A.dat[keepdims], index[keepdims])
    ids = map((x, i) -> view(x, i), A.ids[keepdims], index[keepdims])
    AnnotatedArray(arr, dat, ids)
end


function Base.setindex!(A::AnnotatedArray{T, N}, x, i::Int) where {T, N} 
    setindex!(A.arr, x, i)
end

function Base.setindex!(A::AnnotatedArray{T, N}, x, I::Vararg{Int, N}) where {T, N} 
    setindex!(A.arr, x, I...)
end

function Base.setindex!(A::AnnotatedArray{T, N}, x, I::Vararg{Any, N}) where {T, N}
    Base.setindex!(A.arr, x, map((id, i) -> indices(id, i), A.ids, I))
end

