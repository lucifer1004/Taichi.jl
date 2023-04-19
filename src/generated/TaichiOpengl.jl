module TaichiOpengl

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

struct TiOpenglRuntimeInteropInfo
    get_proc_addr::Ptr{Cvoid}
end

struct TiOpenglMemoryInteropInfo
    buffer::UInt32
    size::Int64
end

struct TiOpenglImageInteropInfo
    texture::UInt32
    target::UInt32
    levels::Int32
    format::UInt32
    width::Int32
    height::Int32
    depth::Int32
end

function ti_import_opengl_runtime(interop_info::TiOpenglRuntimeInteropInfo)
    return ccall((:ti_import_opengl_runtime, libtaichi[]), TaichiCore.TiRuntime, (TiOpenglRuntimeInteropInfo,),
                 interop_info)
end

function ti_export_opengl_runtime(runtime::TaichiCore.TiRuntime, interop_info::TiOpenglRuntimeInteropInfo)
    return ccall((:ti_export_opengl_runtime, libtaichi[]), Cvoid, (TaichiCore.TiRuntime, TiOpenglRuntimeInteropInfo),
                 runtime, interop_info)
end

function ti_import_opengl_memory(runtime::TaichiCore.TiRuntime, interop_info::TiOpenglMemoryInteropInfo)
    return ccall((:ti_import_opengl_memory, libtaichi[]), TaichiCore.TiMemory,
                 (TaichiCore.TiRuntime, TiOpenglMemoryInteropInfo), runtime, interop_info)
end

function ti_export_opengl_memory(runtime::TaichiCore.TiRuntime, memory::TaichiCore.TiMemory,
                                 interop_info::TiOpenglMemoryInteropInfo)
    return ccall((:ti_export_opengl_memory, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemory, TiOpenglMemoryInteropInfo), runtime, memory, interop_info)
end

function ti_import_opengl_image(runtime::TaichiCore.TiRuntime, interop_info::TiOpenglImageInteropInfo)
    return ccall((:ti_import_opengl_image, libtaichi[]), TaichiCore.TiImage,
                 (TaichiCore.TiRuntime, TiOpenglImageInteropInfo), runtime, interop_info)
end

function ti_export_opengl_image(runtime::TaichiCore.TiRuntime, image::TaichiCore.TiImage,
                                interop_info::TiOpenglImageInteropInfo)
    return ccall((:ti_export_opengl_image, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiImage, TiOpenglImageInteropInfo), runtime, image, interop_info)
end

end
