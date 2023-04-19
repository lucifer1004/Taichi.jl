using JSON3
using JuliaFormatter

snaketojulianame(raw) = join(map(uppercasefirst, split(raw, "_")))
getmodulename(raw) = snaketojulianame(match(r"taichi/(.*)\.h", raw)[1])

function loadincenums()
    incenums = Dict{String,Vector{Pair{String,Int}}}()
    for file in readdir(joinpath(@__DIR__, "inc"))
        if !isnothing(match(r".*\.inc\.h", file))
            data = readlines(joinpath(@__DIR__, "inc", file))
            for line in data
                m = match(r"(\w+)\((\w+)\).*", line)
                if !isnothing(m)
                    if !haskey(incenums, m[1])
                        incenums[m[1]] = []
                    end
                    push!(incenums[m[1]], m[2] => length(incenums[m[1]]))
                end
            end
        end
    end
    return incenums
end

function getdecparts(dec)
    prefix = haskey(dec, "vendor") ? "tix" : "ti"
    flagbits = haskey(dec, "flag_bits") ? ["flag", "bits"] : []
    suffix = haskey(dec, "vendor") ? [dec.vendor] : haskey(dec, "is_extension") ? ["ext"] : []
    return [prefix, split(dec.name, "_")..., flagbits..., suffix...]
end

getstructname(dec) = join(map(uppercasefirst, getdecparts(dec)))
getfuncname(dec) = join(getdecparts(dec), "_")

function loadmappings(ti_json)
    typemapping_dict = Dict("uint8_t" => "UInt8",
                            "uint16_t" => "UInt16",
                            "uint32_t" => "UInt32",
                            "uint64_t" => "UInt64",
                            "int8_t" => "Int8",
                            "int16_t" => "Int16",
                            "int32_t" => "Int32",
                            "int64_t" => "Int64",
                            "float" => "Float32",
                            "char" => "Cchar",
                            "const char*" => "Ptr{UInt8}",
                            "const char**" => "Ptr{Ptr{UInt8}}",
                            "void*" => "Ptr{Cvoid}",
                            "const void*" => "Ptr{Cvoid}",
                            "GLuint" => "UInt32",
                            "GLenum" => "UInt32",
                            "GLsizei" => "Int32",
                            "GLsizeiptr" => "Int64")
    modulemapping_dict = Dict{String,String}()

    for m in ti_json.modules
        for d in get(m, "declarations", [])
            if d.type in ["alias", "bit_field", "callback", "handle", "enumeration", "structure", "union"]
                typemapping_dict[d.type * "." * d.name] = getstructname(d) *
                                                          (d.type == "bit_field" ? "FlagBits" : "") *
                                                          (d.type in ["bit_field", "enumeration"] ? ".T" : "")
                modulemapping_dict[d.type * "." * d.name] = getmodulename(m.name)
            end
        end
    end

    return typemapping_dict, modulemapping_dict
end


function main()
    incenums = loadincenums()

    ti_json = JSON3.read(read("taichi.json"))
    typemapping_dict, modulemapping_dict = loadmappings(ti_json)
    typemapping(x) = get(typemapping_dict, x, "Ptr{Cvoid}")
    modulemapping(x) = get(modulemapping_dict, x, "")

    for m in ti_json.modules
        modname = getmodulename(m.name)
        target = joinpath(@__DIR__, "..", "src", "generated", modname * ".jl")

        function scopedtype(x)
            if modulemapping(x) ∉ ["", modname]
                return modulemapping(x) * "." * typemapping(x)
            else
                return typemapping(x)
            end
        end

        open(target, "w") do f
            write(f, "module ", modname, "\n\n")
            write(f, "using EnumX: @enumx\n")
            write(f, "using ..Taichi: libtaichi\n")

            for dep in get(m, "required_modules", [])
                depmod = getmodulename(dep)
                write(f, "using ..", depmod, "\n")
            end

            for d in get(m, "declarations", [])
                if d.type == "handle"
                    write(f, "\nconst ", getstructname(d), " = Ptr{Cvoid}\n")
                elseif d.type == "alias"
                    write(f, "\nconst ", getstructname(d), " = ", scopedtype(d.alias_of), "\n")
                elseif d.type == "enumeration"
                    write(f, "\n@enumx ", getstructname(d), "::Int begin\n")
                    for v in (haskey(d, "cases") ? d.cases : incenums[d.inc_cases])
                        write(f, "    TI_", uppercase(d.name), "_", uppercase(string(first(v))), " = ",
                              string(last(v)),
                              "\n")
                    end
                    write(f, "    TI_", uppercase(d.name), "_MAX_ENUM = Int(0xffffffff)\n")
                    write(f, "end\n\n")
                elseif d.type == "bit_field"
                    write(f, "\n@enumx ", getstructname(d), "FlagBits::Int begin\n")
                    for v in d.bits
                        write(f, "    TI_", uppercase(d.name), "_", uppercase(string(first(v))), "_BIT = 1 << ",
                              string(last(v)),
                              "\n")
                    end
                    write(f, "end\n\n")
                elseif d.type == "union"
                    write(f, "\nconst ", getstructname(d), " = Union{")
                    for field in get(d, "fields", [])
                        write(f, scopedtype(field.type), ", ")
                    end
                    write(f, "}\n")
                elseif d.type == "callback"
                    write(f, "\nconst ", getstructname(d), " = Ptr{Cvoid}\n")
                elseif d.type == "structure"
                    write(f, "\nstruct ", typemapping("structure." * d.name), "\n")
                    for field in get(d, "fields", [])
                        if haskey(field, "name")
                            name = field.name
                        else
                            name = split(field.type, ".")[2]
                        end
                        write(f, "    ", name, "::", scopedtype(field.type), "\n")
                    end
                    write(f, "end\n")
                elseif d.type == "function"
                    write(f, "\nfunction ", getfuncname(d), "(")
                    params = get(d, "parameters", [])
                    arguments = String[]
                    argumenttypes = String[]
                    ret = "Cvoid"
                    for (i, p) in enumerate(params)
                        if haskey(p, "name")
                            name = p.name
                        else
                            name = split(p.type, ".")[2]
                        end
                        if name == "@return"
                            ret = scopedtype(p.type)
                            continue
                        end
                        write(f, name, "::", scopedtype(p.type))
                        push!(arguments, name)
                        push!(argumenttypes, scopedtype(p.type))
                        if i < length(params)
                            write(f, ", ")
                        end
                    end
                    write(f, ")\n")
                    write(f, "    ccall((:", getfuncname(d), ", libtaichi[]), ",
                          ret, ", (", join(argumenttypes, ", "),
                          length(arguments) == 1 ? "," : "",
                          "), ", join(arguments, ", "), ")\n")
                    write(f, "end\n")
                end
            end

            write(f, "\nend\n")
            return
        end
    end

    JuliaFormatter.format(joinpath(@__DIR__, "..", "src", "generated"))

    return
end

main()
