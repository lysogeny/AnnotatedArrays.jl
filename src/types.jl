import DataFrames: AbstractDataFrame, DataFrame, nrow

mutable struct AnnotatedArray{T, N} <: AbstractArray{T, N}
    arr::AbstractArray{T, N}
    dat::NTuple{N, AbstractDataFrame}
    ids::NTuple{N, AbstractVector{String}}
    function (::Type{S})(arr::AbstractArray{T, N}, 
                         dat::NTuple{N, AbstractDataFrame}, 
                         ids::NTuple{N, AbstractVector{String}}) where {T, N, S <: AnnotatedArray}
        if length.(ids) != size(arr) 
            DimensionMismatch("Mismatch in ids ($(length.(ids)) and arr ($(size(arr)))") |> throw
        end
        if nrow.(dat) != size(arr) 
            DimensionMismatch("Mismatch in dat ($(nrow.(dat)) and arr ($(size(arr)))") |> throw
        end
        new{T, N}(arr, dat, ids)
    end
end

const AnnotatedMatrix{T} = AnnotatedArray{T, 2}
const AnnotatedVector{T} = AnnotatedArray{T, 1}

function AnnotatedArray(ann::AbstractArray{T, N}, 
                        dat::NTuple{N, AbstractDataFrame}, 
                        ids::NTuple{N, AbstractVector{String}}) where {T, N}
    AnnotatedArray{T, N}(ann, dat, ids)
end
function AnnotatedArray(ann::AbstractArray{T, N},
                        dat::NTuple{N, AbstractDataFrame}) where {T, N}
    ids = Tuple(string.(1:x) for x in size(ann))
    AnnotatedArray(ann, dat, ids)
end
function AnnotatedArray(ann::AbstractArray{T, N}) where {T, N}
    dat = Tuple(DataFrame(:name => string.(1:x)) for x in size(ann))
    AnnotatedArray(ann, dat)
end

