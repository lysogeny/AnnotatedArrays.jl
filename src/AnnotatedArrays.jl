module AnnotatedArrays

#import Base: getindex, size
import DataFrames
import HDF5

include("types.jl")
include("interfaces.jl")
include("io.jl")
include("accessors.jl")

export AnnotatedArray, AnnotatedMatrix, AnnotatedVector, indices, data, names

end # module
