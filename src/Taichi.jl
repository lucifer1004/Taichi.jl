module Taichi

using CondaPkg: add, add_pip
using Reexport
@reexport using PythonCall
using PythonCall: pycopy!, pynew
using Jl2Py

export ti, np, @ti_func, @ti_kernel

const ti = pynew()
const np = pynew()
const COUNTER = Ref{Int}(0)

macro taichify(func, decorator)
    func_expr = :($func)
    py_func_name = "compiled_julia_func_$(COUNTER[])"
    if func_expr.head == :-> || (func_expr.args[1].head ∉ [:call, :(::)])
        func_expr.head = :function
        if func_expr.args[1].head == :tuple
            func_expr.args[1] = Expr(:call, Symbol(py_func_name), func_expr.args[1].args...)
        elseif func_expr.args[1].head != :(::) || isa(func_expr.args[1].args[1], Symbol)
            func_expr.args[1] = Expr(:call, Symbol(py_func_name), func_expr.args[1])
        else
            func_expr.args[1].args[1] = Expr(:call, Symbol(py_func_name), func_expr.args[1].args[1].args...)
        end
    end
    py_func = jl2py(func_expr)
    py_func.args.args, py_func.args.posonlyargs = py_func.args.posonlyargs, py_func.args.args
    py_func.name = py_func_name
    tmp_file_name = "__tmp__$(COUNTER[]).py"
    COUNTER[] += 1

    quote
        py_str = "$($decorator)\n" * pyconvert(String, unparse($py_func)) * "\n"
        write($tmp_file_name, py_str)
        code = pycompile(py_str; filename=$tmp_file_name, mode="single")
        namespace = pydict(["ti" => ti, map(x -> string(x.first) => x.second, collect(Base.@locals))...])
        pyexec(code, namespace)
        namespace.get($py_func_name)
    end
end

"""
Wrap the given function into a Taichi `func`.
"""
macro ti_func(func)
    quote
        @taichify $func "@ti.func"
    end
end

"""
Wrap the given function into a Taichi `kernel`.
"""
macro ti_kernel(func)
    quote
        @taichify $func "@ti.kernel"
    end
end

function __init__()
    add("numpy")
    add_pip("taichi")
    pycopy!(ti, pyimport("taichi"))
    pycopy!(np, pyimport("numpy"))
    return
end

end
