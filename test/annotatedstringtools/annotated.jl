module test_annotatedstringtools_annotated

function sprint_plain(x)::String
    sprint(io -> show(io, MIME"text/plain"(), x))
end

function sprint_colored(x)::String
    sprint(io -> show(io, MIME"text/plain"(), x); context = :color => true)
end

using Test

using Base: AnnotatedString

annotstr = AnnotatedString("hey there", [(1:3, :face, :blue),
                                         (1:3, :face, :underline),
                                         (5:9, :face, :green)])
@test sprint_plain(annotstr) == "\"hey there\""
@test sprint_colored(annotstr) == "\"\e[34m\e[4mhey\e[39m\e[24m \e[32mthere\e[39m\""

using Base: Annotation, RegionAnnotation

RegionAnnotation #
@test sprint_plain(annotstr.annotations[1]) == """\
@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((1:3, :face, :blue))\
"""

if VERSION >= v"1.13.0-DEV.325"
using Base: RegionIterator, eachregion

RegionIterator{<:AbstractString} #
iter = eachregion(annotstr)

Annotation #
(hey, annots) = first(iter)
@test sprint_plain(annots[1]) == """\
@NamedTuple{label::Symbol, value}((:face, :blue))\
"""
end # if VERSION >= v"1.13.0-DEV.325"

using Jive
# @__END__

using AnnotatedStringTools

@test sprint_plain(annotstr.annotations[1]) == """\
RegionAnnotation((1:3, :face, :blue))\t"Lorem ipsum"\
"""

annots = [ Annotation((:face, :blue)) ]
@test sprint_plain(annots[1]) == """\
Annotation((:face, :blue))\t"Lorem ipsum"\
"""

end # module test_annotatedstringtools_annotated
