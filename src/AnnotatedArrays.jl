module AnnotatedArrays

#import Base: getindex, size
import DataFrames
import HDF5

include("types.jl")
include("interfaces.jl")
include("io.jl")

export AnnotatedArray, AnnotatedMatrix, AnnotatedVector, indices

end # module
