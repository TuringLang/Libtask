###
### This file is generated by running
### ` julia generate_buildjl.jl L/Libtask/build_tarballs.jl`
### in the Yggdrasil root directory, with 2 updates:
### 1. add prefix tp products, see https://github.com/JuliaPackaging/Yggdrasil#binaryproviderjl,
### 2. products filter
###

using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libtask_v1_0"], :libtask_v1_0),
    LibraryProduct(prefix, ["libtask_v1_1"], :libtask_v1_1),
    LibraryProduct(prefix, ["libtask_v1_2"], :libtask_v1_2),
    LibraryProduct(prefix, ["libtask_v1_3"], :libtask_v1_3),
]

products_tmp = filter(products) do prod
    endswith(prod.libnames[1], "$(VERSION.major)_$(VERSION.minor)")
end
length(products_tmp) == 0 && (products_tmp = [products[end]])
products = products_tmp

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/Libtask_jll.jl/releases/download/Libtask-v0.3.0+0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/Libtask.v0.3.0.aarch64-linux-gnu.tar.gz", "e541c0df11d48b45e9334018c014ae0d012b75f92ffbc49fc4ab6eed35593731"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/Libtask.v0.3.0.i686-linux-gnu.tar.gz", "7f68bd21609adf35878f9b16f56151ab5f6f609999a40291ed270c1a4d0331a0"),
    Windows(:i686) => ("$bin_prefix/Libtask.v0.3.0.i686-w64-mingw32.tar.gz", "62950b53a892fb8c699ddbb4ccc9f19b12681f64fbf85a546345d5b0f23dc8d7"),
    MacOS(:x86_64) => ("$bin_prefix/Libtask.v0.3.0.x86_64-apple-darwin14.tar.gz", "fff6523dde93e6dc12b96a8bf1e3c35a78d8dba7cdc95cd0e5dd13225d1972df"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/Libtask.v0.3.0.x86_64-linux-gnu.tar.gz", "be4c590e8f13df31855be20f31c1c4ce98f499fc5173cd35c8e8b72b79e0dc5a"),
    Windows(:x86_64) => ("$bin_prefix/Libtask.v0.3.0.x86_64-w64-mingw32.tar.gz", "267473eb211e5060b98cede7f30336d2a7453542617521f27941d353dcfe42e8"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
