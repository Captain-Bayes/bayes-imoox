
import Pluto
using Pkg

flatmap(args...) = vcat(map(args...)...)


all_files_recursive = flatmap(walkdir("./")) do (root, _dirs, files)
    joinpath.((root,), files)
end

all_notebooks = filter(Pluto.is_pluto_notebook, all_files_recursive)

level = getfield(Pkg, Symbol("UPLEVEL_MINOR"))

for n in all_notebooks
    @info "Updating" n
    Pluto.update_notebook_environment(n; backup=false, level)
end
