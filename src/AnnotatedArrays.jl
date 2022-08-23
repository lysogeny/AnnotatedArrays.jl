module AnnotatedArrays

#import Base: getindex, size
import DataFrames

include("types.jl")
include("interfaces.jl")

export AnnotatedArray, AnnotatedMatrix, AnnotatedVector, indices

end # module
