module Taichi

using CondaPkg: add, add_pip
using PythonCall: pycopy!, pyimport, pynew, pyconvert, pycompile, pyexec, pydict, pystr, pytype, pyprint, pytruth, pyeq,
                  pyne, pyint
using Jl2Py

export ti, np, ti_func, ti_kernel, pytype, pytruth, pyeq, pyne, pyint

const ti = pynew()
const np = pynew()
const COUNTER = Ref{Int}(0)

macro ti_func(func, locals)
    py_func = jl2py(:($func))
    py_func.args.args, py_func.args.posonlyargs = py_func.args.posonlyargs, py_func.args.args

    quote
        py_func_name = "compiled_julia_func_$(COUNTER[])"
        $py_func.name = pystr(py_func_name)
        COUNTER[] += 1
        py_str = "@ti.func\n" * pyconvert(String, unparse($py_func))
        write("__tmp__.py", py_str)
        code = pycompile(py_str; filename="__tmp__.py", mode="exec")
        namespace = pydict(["ti" => ti, $(esc(locals))...])
        pyexec(code, namespace)
        namespace.get(py_func_name)
    end
end

macro ti_kernel(func, locals)
    py_func = jl2py(:($func))
    py_func.args.args, py_func.args.posonlyargs = py_func.args.posonlyargs, py_func.args.args

    quote
        py_func_name = "compiled_julia_kernel_$(COUNTER[])"
        $py_func.name = pystr(py_func_name)
        COUNTER[] += 1
        py_str = "@ti.kernel\n" * pyconvert(String, unparse($py_func))
        write("__tmp__.py", py_str)
        code = pycompile(py_str; filename="__tmp__.py", mode="exec")
        namespace = pydict(["ti" => ti, $(esc(locals))...])
        pyexec(code, namespace)
        namespace.get(py_func_name)
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
