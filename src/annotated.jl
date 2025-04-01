# module AnnotatedStringTools

using Base: Annotation, RegionAnnotation
using Base: AnnotatedString

# julia/base/strings/annotated.jl
#=
const Annotation = NamedTuple{(:label, :value), Tuple{Symbol, Any}}

const RegionAnnotation = NamedTuple{(:region, :label, :value), Tuple{UnitRange{Int}, Symbol, Any}}

struct AnnotatedString{S <: AbstractString} <: AbstractString
    string::S
    annotations::Vector{RegionAnnotation}
end
=#

const sample_text = "Lorem ipsum"
const tab = "\t"

function Base.show(io::IO, mime::MIME"text/plain", annot::Annotation)
    printstyled(io, "Annotation", color = :cyan)
    print(io, "(")
    printstyled(io, "(", repr(annot.label), ", ", repr(annot.value), ")")
    print(io, ")")
    print(io, tab)
    str = sample_text
    region = 1:ncodeunits(str)
    region_annot = RegionAnnotation((region, annot.label, annot.value))
    annotstr = AnnotatedString(str, [region_annot])
    show(io, mime, annotstr)
end

function Base.show(io::IO, mime::MIME"text/plain", region_annot::RegionAnnotation)
    printstyled(io, "RegionAnnotation", color = :cyan)
    print(io, "(")
    printstyled(io, "(", repr(region_annot.region), ", ", repr(region_annot.label), ", ", repr(region_annot.value), ")")
    print(io, ")")
    print(io, tab)
    str = sample_text
    annotstr = AnnotatedString(str, [region_annot])
    show(io, mime, annotstr)
end

if VERSION >= v"1.13.0-DEV.325"
using Base: RegionIterator
#=
struct RegionIterator{S <: AbstractString}
    str::S
    regions::Vector{UnitRange{Int}}
    annotations::Vector{Vector{Annotation}}
end
=#
function Base.show(io::IO, mime::MIME"text/plain", iter::RegionIterator{S}) where S <: AbstractString
    printstyled(io, "RegionIterator", "{", S, "}", color = :cyan)
    indent = repeat(' ', 2)
    for (str, annots) in iter
        print(io, "\n")
        print(io, indent)
        print(io, "(", repr(str), ", ")
        if isempty(annots)
            print(io, [])
            print(io, ")")
            print(io, tab)
            show(io, mime, str)
        else
            print(io, values.(annots))
            print(io, ")")
            print(io, tab)
            annotations = map(annots) do annot
                region = 1:ncodeunits(str)
                region_annot = RegionAnnotation((region, annot...))
            end
            annotstr = AnnotatedString(str, annotations)
            show(io, mime, annotstr)
        end
    end
end
end # if VERSION >= v"1.13.0-DEV.325"

# module AnnotatedStringTools
