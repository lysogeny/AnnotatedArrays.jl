abstract type HDF5Dialect end

struct Loom <: HDF5Dialect
end

function determine_dialect(s::AbstractString)
    types = Dict{String, DataType}(
        "loom" => Loom
    )
    types[String(s)]
end

function AnnotatedArray(f::HDF5.File)
    # Determine type of H5 file
    ending = split(f.filename, '.')[end]
    AnnotatedArray(determine_dialect(ending), f)
end

function AnnotatedArray(::Type{Loom}, f::HDF5.File)
    # Read loom file column and row tables
    col_attrs = DataFrame(HDF5.read(f, "col_attrs")...)
    row_attrs = DataFrame(HDF5.read(f, "row_attrs")...)
    col_names = collect(col_attrs[:,"CellID"])
    row_names = collect(row_attrs[:,"Gene"])
    # read layers
    layers = HDF5.read(f, "layers")
    matrix = HDF5.read(f, "matrix")
    layer_names = keys(layers) |> collect
    lay_names = vcat(["matrix"], ["layers/$lay" for lay in layer_names])
    lay_attrs = DataFrame(:name => lay_names, 
                          :original_name => vcat(["matrix"], layer_names))
    stacked_layers = cat(matrix, [layers[layer] for layer in layer_names]..., dims=3)
    AnnotatedArray(
        stacked_layers, 
        (col_attrs, row_attrs, lay_attrs),
        (col_names, row_names, lay_names)
   )
end

