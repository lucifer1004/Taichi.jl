module TaichiUnity

using EnumX: @enumx
using ..Taichi: libtaichi
using ..TaichiCore

const TixNativeBufferUnity = Ptr{Cvoid}

const TixAsyncTaskUnity = Ptr{Cvoid}

function tix_import_native_runtime_unity()
    return ccall((:tix_import_native_runtime_unity, libtaichi[]), TaichiCore.TiRuntime, ())
end

function tix_enqueue_task_async_unity(user_data::Ptr{Cvoid}, async_task::TixAsyncTaskUnity)
    return ccall((:tix_enqueue_task_async_unity, libtaichi[]), Cvoid, (Ptr{Cvoid}, TixAsyncTaskUnity), user_data,
                 async_task)
end

function tix_launch_kernel_async_unity(runtime::TaichiCore.TiRuntime, kernel::TaichiCore.TiKernel, arg_count::UInt32,
                                       args::TaichiCore.TiArgument)
    return ccall((:tix_launch_kernel_async_unity, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiKernel, UInt32, TaichiCore.TiArgument), runtime, kernel, arg_count,
                 args)
end

function tix_launch_compute_graph_async_unity(runtime::TaichiCore.TiRuntime, compute_graph::TaichiCore.TiComputeGraph,
                                              arg_count::UInt32, args::TaichiCore.TiNamedArgument)
    return ccall((:tix_launch_compute_graph_async_unity, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiComputeGraph, UInt32, TaichiCore.TiNamedArgument), runtime,
                 compute_graph, arg_count, args)
end

function tix_copy_memory_to_native_buffer_async_unity(runtime::TaichiCore.TiRuntime, dst::TixNativeBufferUnity,
                                                      dst_offset::UInt64, src::TaichiCore.TiMemorySlice)
    return ccall((:tix_copy_memory_to_native_buffer_async_unity, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TixNativeBufferUnity, UInt64, TaichiCore.TiMemorySlice), runtime, dst,
                 dst_offset, src)
end

function tix_copy_memory_device_to_host_unity(runtime::TaichiCore.TiRuntime, dst::Ptr{Cvoid}, dst_offset::UInt64,
                                              src::TaichiCore.TiMemorySlice)
    return ccall((:tix_copy_memory_device_to_host_unity, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, Ptr{Cvoid}, UInt64, TaichiCore.TiMemorySlice), runtime, dst, dst_offset, src)
end

function tix_copy_memory_host_to_device_unity(runtime::TaichiCore.TiRuntime, dst::TaichiCore.TiMemorySlice,
                                              src::Ptr{Cvoid}, src_offset::UInt64)
    return ccall((:tix_copy_memory_host_to_device_unity, libtaichi[]), Cvoid,
                 (TaichiCore.TiRuntime, TaichiCore.TiMemorySlice, Ptr{Cvoid}, UInt64), runtime, dst, src, src_offset)
end

function tix_submit_async_unity(runtime::TaichiCore.TiRuntime)
    return ccall((:tix_submit_async_unity, libtaichi[]), Ptr{Cvoid}, (TaichiCore.TiRuntime,), runtime)
end

end
