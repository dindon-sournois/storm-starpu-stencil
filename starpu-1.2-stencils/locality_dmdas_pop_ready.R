#!/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
srcfile <- args[1]
name <- args[2]
print(srcfile)

output <- paste("dmas_pop_ready_", name, sep="")
output <- paste(output, ".pdf", sep="")
print(output)

pdf(file = output)

pop <- read.table(srcfile, check.names=TRUE, header=TRUE)

percent <- function(pop){
total <- pop[[3]]
value <- pop[[4]]
100*value/total
}
visited <- function(pop){
pop[[4]]
}

xmax <- max(visited(pop))

res <- hist(visited(pop),
     main="dmdas ready tasks",
     xlab="Visited/Total",
     border="blue",
     col="green",
     xlim=c(1,100),
     las=0,
     breaks=xmax)

plot(res$count, log="x", type='h', lwd=10, lend=2)

dev.off()
