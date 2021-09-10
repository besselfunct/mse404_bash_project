# Check and see if the necessary packages are installed
try
	using UnicodePlots
catch e
	using Pkg
	Pkg.add("UnicodePlots")
end
try
	using CSV
catch e
	using Pkg
	Pkg.add("CSV")
end
try
	using DataFrames
catch e
	using Pkg
	Pkg.add("CSV")
end
df = DataFrame(CSV.File(ARGS[1]))
display(lineplot(df[:,2], title = ARGS[2], xlabel = string(ARGS[3])*" - "*string(ARGS[4]), ylabel = "Adj. Clos. Pr."))
