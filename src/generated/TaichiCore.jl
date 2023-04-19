module TaichiCore

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiPlatform

const TiBool = UInt32

const TiFlags = UInt32

const TiRuntime = Ptr{Cvoid}

const TiAotModule = Ptr{Cvoid}

const TiMemory = Ptr{Cvoid}

const TiImage = Ptr{Cvoid}

const TiSampler = Ptr{Cvoid}

const TiKernel = Ptr{Cvoid}

const TiComputeGraph = Ptr{Cvoid}

@enumx TiError::Int begin
    TI_ERROR_SUCCESS = 0
    TI_ERROR_NOT_SUPPORTED = -1
    TI_ERROR_CORRUPTED_DATA = -2
    TI_ERROR_NAME_NOT_FOUND = -3
    TI_ERROR_INVALID_ARGUMENT = -4
    TI_ERROR_ARGUMENT_NULL = -5
    TI_ERROR_ARGUMENT_OUT_OF_RANGE = -6
    TI_ERROR_ARGUMENT_NOT_FOUND = -7
    TI_ERROR_INVALID_INTEROP = -8
    TI_ERROR_INVALID_STATE = -9
    TI_ERROR_INCOMPATIBLE_MODULE = -10
    TI_ERROR_OUT_OF_MEMORY = -11
    TI_ERROR_MAX_ENUM = Int(0xffffffff)
end


@enumx TiArch::Int begin
    TI_ARCH_RESERVED = 0
    TI_ARCH_VULKAN = 1
    TI_ARCH_METAL = 2
    TI_ARCH_CUDA = 3
    TI_ARCH_X64 = 4
    TI_ARCH_ARM64 = 5
    TI_ARCH_OPENGL = 6
    TI_ARCH_GLES = 7
    TI_ARCH_MAX_ENUM = Int(0xffffffff)
end


@enumx TiCapability::Int begin
    TI_CAPABILITY_RESERVED = 0
    TI_CAPABILITY_SPIRV_VERSION = 1
    TI_CAPABILITY_SPIRV_HAS_INT8 = 2
    TI_CAPABILITY_SPIRV_HAS_INT16 = 3
    TI_CAPABILITY_SPIRV_HAS_INT64 = 4
    TI_CAPABILITY_SPIRV_HAS_FLOAT16 = 5
    TI_CAPABILITY_SPIRV_HAS_FLOAT64 = 6
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_INT64 = 7
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT16 = 8
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT16_ADD = 9
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT16_MINMAX = 10
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT = 11
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT_ADD = 12
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT_MINMAX = 13
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT64 = 14
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT64_ADD = 15
    TI_CAPABILITY_SPIRV_HAS_ATOMIC_FLOAT64_MINMAX = 16
    TI_CAPABILITY_SPIRV_HAS_VARIABLE_PTR = 17
    TI_CAPABILITY_SPIRV_HAS_PHYSICAL_STORAGE_BUFFER = 18
    TI_CAPABILITY_SPIRV_HAS_SUBGROUP_BASIC = 19
    TI_CAPABILITY_SPIRV_HAS_SUBGROUP_VOTE = 20
    TI_CAPABILITY_SPIRV_HAS_SUBGROUP_ARITHMETIC = 21
    TI_CAPABILITY_SPIRV_HAS_SUBGROUP_BALLOT = 22
    TI_CAPABILITY_SPIRV_HAS_NON_SEMANTIC_INFO = 23
    TI_CAPABILITY_SPIRV_HAS_NO_INTEGER_WRAP_DECORATION = 24
    TI_CAPABILITY_MAX_ENUM = Int(0xffffffff)
end


struct TiCapabilityLevelInfo
    capability::TiCapability.T
    level::UInt32
end

@enumx TiDataType::Int begin
    TI_DATA_TYPE_F16 = 0
    TI_DATA_TYPE_F32 = 1
    TI_DATA_TYPE_F64 = 2
    TI_DATA_TYPE_I8 = 3
    TI_DATA_TYPE_I16 = 4
    TI_DATA_TYPE_I32 = 5
    TI_DATA_TYPE_I64 = 6
    TI_DATA_TYPE_U1 = 7
    TI_DATA_TYPE_U8 = 8
    TI_DATA_TYPE_U16 = 9
    TI_DATA_TYPE_U32 = 10
    TI_DATA_TYPE_U64 = 11
    TI_DATA_TYPE_GEN = 12
    TI_DATA_TYPE_UNKNOWN = 13
    TI_DATA_TYPE_MAX_ENUM = Int(0xffffffff)
end


@enumx TiArgumentType::Int begin
    TI_ARGUMENT_TYPE_I32 = 0
    TI_ARGUMENT_TYPE_F32 = 1
    TI_ARGUMENT_TYPE_NDARRAY = 2
    TI_ARGUMENT_TYPE_TEXTURE = 3
    TI_ARGUMENT_TYPE_SCALAR = 4
    TI_ARGUMENT_TYPE_MAX_ENUM = Int(0xffffffff)
end


@enumx TiMemoryUsageFlagBits::Int begin
    TI_MEMORY_USAGE_STORAGE_BIT = 1 << 0
    TI_MEMORY_USAGE_UNIFORM_BIT = 1 << 1
    TI_MEMORY_USAGE_VERTEX_BIT = 1 << 2
    TI_MEMORY_USAGE_INDEX_BIT = 1 << 3
end


struct TiMemoryAllocateInfo
    size::UInt64
    host_write::TiBool
    host_read::TiBool
    export_sharing::TiBool
    usage::TiMemoryUsageFlagBits.T
end

struct TiMemorySlice
    memory::TiMemory
    offset::UInt64
    size::UInt64
end

struct TiNdShape
    dim_count::UInt32
    dims::UInt32
end

struct TiNdArray
    memory::TiMemory
    shape::TiNdShape
    elem_shape::TiNdShape
    elem_type::TiDataType.T
end

@enumx TiImageUsageFlagBits::Int begin
    TI_IMAGE_USAGE_STORAGE_BIT = 1 << 0
    TI_IMAGE_USAGE_SAMPLED_BIT = 1 << 1
    TI_IMAGE_USAGE_ATTACHMENT_BIT = 1 << 2
end


@enumx TiImageDimension::Int begin
    TI_IMAGE_DIMENSION_1D = 0
    TI_IMAGE_DIMENSION_2D = 1
    TI_IMAGE_DIMENSION_3D = 2
    TI_IMAGE_DIMENSION_1D_ARRAY = 3
    TI_IMAGE_DIMENSION_2D_ARRAY = 4
    TI_IMAGE_DIMENSION_CUBE = 5
    TI_IMAGE_DIMENSION_MAX_ENUM = Int(0xffffffff)
end


@enumx TiImageLayout::Int begin
    TI_IMAGE_LAYOUT_UNDEFINED = 0
    TI_IMAGE_LAYOUT_SHADER_READ = 1
    TI_IMAGE_LAYOUT_SHADER_WRITE = 2
    TI_IMAGE_LAYOUT_SHADER_READ_WRITE = 3
    TI_IMAGE_LAYOUT_COLOR_ATTACHMENT = 4
    TI_IMAGE_LAYOUT_COLOR_ATTACHMENT_READ = 5
    TI_IMAGE_LAYOUT_DEPTH_ATTACHMENT = 6
    TI_IMAGE_LAYOUT_DEPTH_ATTACHMENT_READ = 7
    TI_IMAGE_LAYOUT_TRANSFER_DST = 8
    TI_IMAGE_LAYOUT_TRANSFER_SRC = 9
    TI_IMAGE_LAYOUT_PRESENT_SRC = 10
    TI_IMAGE_LAYOUT_MAX_ENUM = Int(0xffffffff)
end


@enumx TiFormat::Int begin
    TI_FORMAT_UNKNOWN = 0
    TI_FORMAT_R8 = 1
    TI_FORMAT_RG8 = 2
    TI_FORMAT_RGBA8 = 3
    TI_FORMAT_RGBA8SRGB = 4
    TI_FORMAT_BGRA8 = 5
    TI_FORMAT_BGRA8SRGB = 6
    TI_FORMAT_R8U = 7
    TI_FORMAT_RG8U = 8
    TI_FORMAT_RGBA8U = 9
    TI_FORMAT_R8I = 10
    TI_FORMAT_RG8I = 11
    TI_FORMAT_RGBA8I = 12
    TI_FORMAT_R16 = 13
    TI_FORMAT_RG16 = 14
    TI_FORMAT_RGB16 = 15
    TI_FORMAT_RGBA16 = 16
    TI_FORMAT_R16U = 17
    TI_FORMAT_RG16U = 18
    TI_FORMAT_RGB16U = 19
    TI_FORMAT_RGBA16U = 20
    TI_FORMAT_R16I = 21
    TI_FORMAT_RG16I = 22
    TI_FORMAT_RGB16I = 23
    TI_FORMAT_RGBA16I = 24
    TI_FORMAT_R16F = 25
    TI_FORMAT_RG16F = 26
    TI_FORMAT_RGB16F = 27
    TI_FORMAT_RGBA16F = 28
    TI_FORMAT_R32U = 29
    TI_FORMAT_RG32U = 30
    TI_FORMAT_RGB32U = 31
    TI_FORMAT_RGBA32U = 32
    TI_FORMAT_R32I = 33
    TI_FORMAT_RG32I = 34
    TI_FORMAT_RGB32I = 35
    TI_FORMAT_RGBA32I = 36
    TI_FORMAT_R32F = 37
    TI_FORMAT_RG32F = 38
    TI_FORMAT_RGB32F = 39
    TI_FORMAT_RGBA32F = 40
    TI_FORMAT_DEPTH16 = 41
    TI_FORMAT_DEPTH24STENCIL8 = 42
    TI_FORMAT_DEPTH32F = 43
    TI_FORMAT_MAX_ENUM = Int(0xffffffff)
end


struct TiImageOffset
    x::UInt32
    y::UInt32
    z::UInt32
    array_layer_offset::UInt32
end

struct TiImageExtent
    width::UInt32
    height::UInt32
    depth::UInt32
    array_layer_count::UInt32
end

struct TiImageAllocateInfo
    dimension::TiImageDimension.T
    extent::TiImageExtent
    mip_level_count::UInt32
    format::TiFormat.T
    export_sharing::TiBool
    usage::TiImageUsageFlagBits.T
end

struct TiImageSlice
    image::TiImage
    offset::TiImageOffset
    extent::TiImageExtent
    mip_level::UInt32
end

@enumx TiFilter::Int begin
    TI_FILTER_NEAREST = 0
    TI_FILTER_LINEAR = 1
    TI_FILTER_MAX_ENUM = Int(0xffffffff)
end


@enumx TiAddressMode::Int begin
    TI_ADDRESS_MODE_REPEAT = 0
    TI_ADDRESS_MODE_MIRRORED_REPEAT = 1
    TI_ADDRESS_MODE_CLAMP_TO_EDGE = 2
    TI_ADDRESS_MODE_MAX_ENUM = Int(0xffffffff)
end


struct TiSamplerCreateInfo
    mag_filter::TiFilter.T
    min_filter::TiFilter.T
    address_mode::TiAddressMode.T
    max_anisotropy::Float32
end

struct TiTexture
    image::TiImage
    sampler::TiSampler
    dimension::TiImageDimension.T
    extent::TiImageExtent
    format::TiFormat.T
end

const TiScalarValue = Union{}

struct TiScalar
    type::TiDataType.T
    value::TiScalarValue
end

const TiArgumentValue = Union{}

struct TiArgument
    type::TiArgumentType.T
    value::TiArgumentValue
end

struct TiNamedArgument
    name::Ptr{UInt8}
    argument::TiArgument
end

function ti_get_version()
    return ccall((:ti_get_version, libtaichi[]), UInt32, ())
end

function ti_get_available_archs(arch_count::UInt32, archs::TiArch.T)
    return ccall((:ti_get_available_archs, libtaichi[]), Cvoid, (UInt32, TiArch.T), arch_count, archs)
end

function ti_get_last_error(message_size::UInt64, message::Cchar)
    return ccall((:ti_get_last_error, libtaichi[]), TiError.T, (UInt64, Cchar), message_size, message)
end

function ti_set_last_error(error::TiError.T, message::Ptr{UInt8})
    return ccall((:ti_set_last_error, libtaichi[]), Cvoid, (TiError.T, Ptr{UInt8}), error, message)
end

function ti_create_runtime(arch::TiArch.T, device_index::UInt32)
    return ccall((:ti_create_runtime, libtaichi[]), TiRuntime, (TiArch.T, UInt32), arch, device_index)
end

function ti_destroy_runtime(runtime::TiRuntime)
    return ccall((:ti_destroy_runtime, libtaichi[]), Cvoid, (TiRuntime,), runtime)
end

function ti_set_runtime_capabilities_ext(runtime::TiRuntime, capability_count::UInt32,
                                         capabilities::TiCapabilityLevelInfo)
    return ccall((:ti_set_runtime_capabilities_ext, libtaichi[]), Cvoid, (TiRuntime, UInt32, TiCapabilityLevelInfo),
                 runtime, capability_count, capabilities)
end

function ti_get_runtime_capabilities(runtime::TiRuntime, capability_count::UInt32, capabilities::TiCapabilityLevelInfo)
    return ccall((:ti_get_runtime_capabilities, libtaichi[]), Cvoid, (TiRuntime, UInt32, TiCapabilityLevelInfo),
                 runtime, capability_count, capabilities)
end

function ti_allocate_memory(runtime::TiRuntime, allocate_info::TiMemoryAllocateInfo)
    return ccall((:ti_allocate_memory, libtaichi[]), TiMemory, (TiRuntime, TiMemoryAllocateInfo), runtime,
                 allocate_info)
end

function ti_free_memory(runtime::TiRuntime, memory::TiMemory)
    return ccall((:ti_free_memory, libtaichi[]), Cvoid, (TiRuntime, TiMemory), runtime, memory)
end

function ti_map_memory(runtime::TiRuntime, memory::TiMemory)
    return ccall((:ti_map_memory, libtaichi[]), Ptr{Cvoid}, (TiRuntime, TiMemory), runtime, memory)
end

function ti_unmap_memory(runtime::TiRuntime, memory::TiMemory)
    return ccall((:ti_unmap_memory, libtaichi[]), Cvoid, (TiRuntime, TiMemory), runtime, memory)
end

function ti_allocate_image(runtime::TiRuntime, allocate_info::TiImageAllocateInfo)
    return ccall((:ti_allocate_image, libtaichi[]), TiImage, (TiRuntime, TiImageAllocateInfo), runtime, allocate_info)
end

function ti_free_image(runtime::TiRuntime, image::TiImage)
    return ccall((:ti_free_image, libtaichi[]), Cvoid, (TiRuntime, TiImage), runtime, image)
end

function ti_create_sampler(runtime::TiRuntime, create_info::TiSamplerCreateInfo)
    return ccall((:ti_create_sampler, libtaichi[]), TiSampler, (TiRuntime, TiSamplerCreateInfo), runtime, create_info)
end

function ti_destroy_sampler(runtime::TiRuntime, sampler::TiSampler)
    return ccall((:ti_destroy_sampler, libtaichi[]), Cvoid, (TiRuntime, TiSampler), runtime, sampler)
end

function ti_copy_memory_device_to_device(runtime::TiRuntime, dst_memory::TiMemorySlice, src_memory::TiMemorySlice)
    return ccall((:ti_copy_memory_device_to_device, libtaichi[]), Cvoid, (TiRuntime, TiMemorySlice, TiMemorySlice),
                 runtime, dst_memory, src_memory)
end

function ti_copy_image_device_to_device(runtime::TiRuntime, dst_image::TiImageSlice, src_image::TiImageSlice)
    return ccall((:ti_copy_image_device_to_device, libtaichi[]), Cvoid, (TiRuntime, TiImageSlice, TiImageSlice),
                 runtime, dst_image, src_image)
end

function ti_track_image_ext(runtime::TiRuntime, image::TiImage, layout::TiImageLayout.T)
    return ccall((:ti_track_image_ext, libtaichi[]), Cvoid, (TiRuntime, TiImage, TiImageLayout.T), runtime, image,
                 layout)
end

function ti_transition_image(runtime::TiRuntime, image::TiImage, layout::TiImageLayout.T)
    return ccall((:ti_transition_image, libtaichi[]), Cvoid, (TiRuntime, TiImage, TiImageLayout.T), runtime, image,
                 layout)
end

function ti_launch_kernel(runtime::TiRuntime, kernel::TiKernel, arg_count::UInt32, args::TiArgument)
    return ccall((:ti_launch_kernel, libtaichi[]), Cvoid, (TiRuntime, TiKernel, UInt32, TiArgument), runtime, kernel,
                 arg_count, args)
end

function ti_launch_compute_graph(runtime::TiRuntime, compute_graph::TiComputeGraph, arg_count::UInt32,
                                 args::TiNamedArgument)
    return ccall((:ti_launch_compute_graph, libtaichi[]), Cvoid, (TiRuntime, TiComputeGraph, UInt32, TiNamedArgument),
                 runtime, compute_graph, arg_count, args)
end

function ti_flush(runtime::TiRuntime)
    return ccall((:ti_flush, libtaichi[]), Cvoid, (TiRuntime,), runtime)
end

function ti_wait(runtime::TiRuntime)
    return ccall((:ti_wait, libtaichi[]), Cvoid, (TiRuntime,), runtime)
end

function ti_load_aot_module(runtime::TiRuntime, module_path::Ptr{UInt8})
    return ccall((:ti_load_aot_module, libtaichi[]), TiAotModule, (TiRuntime, Ptr{UInt8}), runtime, module_path)
end

function ti_create_aot_module(runtime::TiRuntime, tcm::Ptr{Cvoid}, size::UInt64)
    return ccall((:ti_create_aot_module, libtaichi[]), TiAotModule, (TiRuntime, Ptr{Cvoid}, UInt64), runtime, tcm, size)
end

function ti_destroy_aot_module(aot_module::TiAotModule)
    return ccall((:ti_destroy_aot_module, libtaichi[]), Cvoid, (TiAotModule,), aot_module)
end

function ti_get_aot_module_kernel(aot_module::TiAotModule, name::Ptr{UInt8})
    return ccall((:ti_get_aot_module_kernel, libtaichi[]), TiKernel, (TiAotModule, Ptr{UInt8}), aot_module, name)
end

function ti_get_aot_module_compute_graph(aot_module::TiAotModule, name::Ptr{UInt8})
    return ccall((:ti_get_aot_module_compute_graph, libtaichi[]), TiComputeGraph, (TiAotModule, Ptr{UInt8}), aot_module,
                 name)
end

end
