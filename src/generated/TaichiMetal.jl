module TaichiMetal

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

const TiNsBundle = Ptr{Cvoid}

const TiMtlDevice = Ptr{Cvoid}

const TiMtlBuffer = Ptr{Cvoid}

const TiMtlTexture = Ptr{Cvoid}

struct TiMetalRuntimeInteropInfo
    bundle::TiNsBundle
    device::TiMtlDevice
end

struct TiMetalMemoryInteropInfo
    buffer::TiMtlBuffer
end

struct TiMetalImageInteropInfo
    texture::TiMtlTexture
end

function ti_import_metal_runtime(interop_info::TiMetalRuntimeInteropInfo)
    return ccall((:ti_import_metal_runtime, libtaichi[]), TaichiCore.TiRuntime, (TiMetalRuntimeInteropInfo,),
                 interop_info)
end

function ti_export_metal_runtime(runtime::TaichiCore.TiRuntime, interop_info::TiMetalRuntimeInteropInfo)
    return ccall((:ti_export_metal_runtime, libtaichi[]), Cvoid, (TaichiCore.TiRuntime, TiMetalRuntimeInteropInfo),
                 runtime, interop_info)
end

function ti_import_metal_memory(runtime::TaichiCore.TiRuntime, interop_info::TiMetalMemoryInteropInfo)
    return ccall((:ti_import_metal_memory, libtaichi[]), TaichiCore.TiMemory,
                 (TaichiCore.TiRuntime, TiMetalMemoryInteropInfo), runtime, interop_info)
end

function ti_export_metal_memory(runtime::TaichiCore.TiRuntime, memory::TaichiCore.TiMemory,
                                interop_info::TiMetalMemoryInteropInfo)
    return ccall((:ti_export_metal_memory, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemory, TiMetalMemoryInteropInfo), runtime, memory, interop_info)
end

function ti_import_metal_image(runtime::TaichiCore.TiRuntime, interop_info::TiMetalImageInteropInfo)
    return ccall((:ti_import_metal_image, libtaichi[]), TaichiCore.TiImage,
                 (TaichiCore.TiRuntime, TiMetalImageInteropInfo), runtime, interop_info)
end

function ti_export_metal_image(runtime::TaichiCore.TiRuntime, image::TaichiCore.TiImage,
                               interop_info::TiMetalImageInteropInfo)
    return ccall((:ti_export_metal_image, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiImage, TiMetalImageInteropInfo), runtime, image, interop_info)
end

end
