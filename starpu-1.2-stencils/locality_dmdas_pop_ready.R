#!/bin/env Rscript

pdf(file = "dmdas_pop_ready.pdf")

pop <- read.table("output/dmdas_pop_ready.data",
                    check.names=TRUE,
                    header=TRUE)

xmax <- max(pop[4])

res <- hist(pop[[4]],
     main="dmdas ready tasks",
     xlab="Visited",
     border="blue",
     col="green",
     xlim=c(1,100),
     las=0,
     breaks=xmax)

plot(res$count, log="x", type='h', lwd=10, lend=2)

dev.off()
