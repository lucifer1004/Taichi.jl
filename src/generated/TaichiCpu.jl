module TaichiCpu

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

struct TiCpuMemoryInteropInfo
    ptr::Ptr{Cvoid}
    size::UInt64
end

function ti_export_cpu_memory(runtime::TaichiCore.TiRuntime, memory::TaichiCore.TiMemory,
                              interop_info::TiCpuMemoryInteropInfo)
    return ccall((:ti_export_cpu_memory, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemory, TiCpuMemoryInteropInfo), runtime, memory, interop_info)
end

end
