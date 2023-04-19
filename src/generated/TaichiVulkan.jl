module TaichiVulkan

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

struct TiVulkanRuntimeInteropInfo
    get_instance_proc_addr::Ptr{Cvoid}
    api_version::UInt32
    instance::Ptr{Cvoid}
    physical_device::Ptr{Cvoid}
    device::Ptr{Cvoid}
    compute_queue::Ptr{Cvoid}
    compute_queue_family_index::UInt32
    graphics_queue::Ptr{Cvoid}
    graphics_queue_family_index::UInt32
end

struct TiVulkanMemoryInteropInfo
    buffer::Ptr{Cvoid}
    size::UInt64
    usage::Ptr{Cvoid}
    memory::Ptr{Cvoid}
    offset::UInt64
end

struct TiVulkanImageInteropInfo
    image::Ptr{Cvoid}
    image_type::Ptr{Cvoid}
    format::Ptr{Cvoid}
    extent::Ptr{Cvoid}
    mip_level_count::UInt32
    array_layer_count::UInt32
    sample_count::Ptr{Cvoid}
    tiling::Ptr{Cvoid}
    usage::Ptr{Cvoid}
end

function ti_create_vulkan_runtime_ext(api_version::UInt32, instance_extension_count::UInt32,
                                      instance_extensions::Ptr{Ptr{UInt8}}, device_extension_count::UInt32,
                                      device_extensions::Ptr{Ptr{UInt8}})
    return ccall((:ti_create_vulkan_runtime_ext, libtaichi[]), TaichiCore.TiRuntime,
                 (UInt32, UInt32, Ptr{Ptr{UInt8}}, UInt32, Ptr{Ptr{UInt8}}), api_version, instance_extension_count,
                 instance_extensions, device_extension_count, device_extensions)
end

function ti_import_vulkan_runtime(interop_info::TiVulkanRuntimeInteropInfo)
    return ccall((:ti_import_vulkan_runtime, libtaichi[]), TaichiCore.TiRuntime, (TiVulkanRuntimeInteropInfo,),
                 interop_info)
end

function ti_export_vulkan_runtime(runtime::TaichiCore.TiRuntime, interop_info::TiVulkanRuntimeInteropInfo)
    return ccall((:ti_export_vulkan_runtime, libtaichi[]), Cvoid, (TaichiCore.TiRuntime, TiVulkanRuntimeInteropInfo),
                 runtime, interop_info)
end

function ti_import_vulkan_memory(runtime::TaichiCore.TiRuntime, interop_info::TiVulkanMemoryInteropInfo)
    return ccall((:ti_import_vulkan_memory, libtaichi[]), TaichiCore.TiMemory,
                 (TaichiCore.TiRuntime, TiVulkanMemoryInteropInfo), runtime, interop_info)
end

function ti_export_vulkan_memory(runtime::TaichiCore.TiRuntime, memory::TaichiCore.TiMemory,
                                 interop_info::TiVulkanMemoryInteropInfo)
    return ccall((:ti_export_vulkan_memory, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemory, TiVulkanMemoryInteropInfo), runtime, memory, interop_info)
end

function ti_import_vulkan_image(runtime::TaichiCore.TiRuntime, interop_info::TiVulkanImageInteropInfo,
                                view_type::Ptr{Cvoid}, layout::Ptr{Cvoid})
    return ccall((:ti_import_vulkan_image, libtaichi[]), TaichiCore.TiImage,
                 (TaichiCore.TiRuntime, TiVulkanImageInteropInfo, Ptr{Cvoid}, Ptr{Cvoid}), runtime, interop_info,
                 view_type, layout)
end

function ti_export_vulkan_image(runtime::TaichiCore.TiRuntime, image::TaichiCore.TiImage,
                                interop_info::TiVulkanImageInteropInfo)
    return ccall((:ti_export_vulkan_image, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiImage, TiVulkanImageInteropInfo), runtime, image, interop_info)
end

end
