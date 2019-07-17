setwd("~/Dropbox/stacks2_analysis/paper1_files/3cb")
library(gplots)


bluecols <- colorRampPalette(c("white", "dodgerblue4"))
redcols <- colorRampPalette(c("white", "darkred"))
blackcols <- colorRampPalette(c("white", "gray1"))
browncols <- colorRampPalette(c("white", "saddlebrown"))
violetcols <- colorRampPalette(c("white", "darkorchid4"))

pdf("fstheatmap.pdf")
dfmat <- as.matrix(read.table("fst.tsv", header = T, row.names = 1, sep = "\t"))
heatmap.2(dfmat, col = blackcols(100), Rowv=FALSE,  cellnote = round(dfmat, 2), notecex=0.9, notecol="black", Colv = FALSE, distfun=function(x) dist(x, method="euclidean"), density.info="none", trace="none", symm=F,symkey=F, scale="none", key = T, hclustfun=function(x) hclust(x, method="average"))
dev.off()

pdf("fixdiffheatmap.pdf")
dfmat <- as.matrix(read.table("fixed_differences.tsv", header = T, row.names = 1, sep = "\t"))
heatmap.2(dfmat, col = browncols(100), Rowv=FALSE,  cellnote = dfmat, notecex=0.9, notecol="black", Colv = FALSE, distfun=function(x) dist(x, method="euclidean"), density.info="none", trace="none", symm=F,symkey=F, scale="none", key = T, hclustfun=function(x) hclust(x, method="average"))
dev.off()

pdf("destheatmap.pdf")
dfmat <- as.matrix(read.table("dest.tsv", header = T, row.names = 1, sep = "\t"))
heatmap.2(dfmat, col = violetcols(100), Rowv=FALSE,  cellnote = round(dfmat, 2), notecex=0.9, notecol="black", Colv = FALSE, distfun=function(x) dist(x, method="euclidean"), density.info="none", trace="none", symm=F,symkey=F, scale="none", key = T, hclustfun=function(x) hclust(x, method="average"))
dev.off()

pdf("phistheatmap.pdf")
dfmat <- as.matrix(read.table("phist.tsv", header = T, row.names = 1, sep = "\t"))
heatmap.2(dfmat, col = redcols(100), Rowv=FALSE,  cellnote = round(dfmat, 2), notecex=0.9, notecol="black", Colv = FALSE, distfun=function(x) dist(x, method="euclidean"), density.info="none", trace="none", symm=F,symkey=F, scale="none", key = T, hclustfun=function(x) hclust(x, method="average"))
dev.off()

pdf("fstprimeheatmap.pdf")
dfmat <- as.matrix(read.table("fstprime.tsv", header = T, row.names = 1, sep = "\t"))
heatmap.2(dfmat, col = bluecols(100), Rowv=FALSE,  cellnote = round(dfmat, 2), notecex=0.9, notecol="black", Colv = FALSE, distfun=function(x) dist(x, method="euclidean"), density.info="none", trace="none", symm=F,symkey=F, scale="none", key = T, hclustfun=function(x) hclust(x, method="average"))
dev.off()