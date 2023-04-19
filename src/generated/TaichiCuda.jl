module TaichiCuda

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

struct TiCudaMemoryInteropInfo
    ptr::Ptr{Cvoid}
    size::UInt64
end

function ti_export_cuda_memory(runtime::TaichiCore.TiRuntime, memory::TaichiCore.TiMemory,
                               interop_info::TiCudaMemoryInteropInfo)
    return ccall((:ti_export_cuda_memory, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemory, TiCudaMemoryInteropInfo), runtime, memory, interop_info)
end

end
