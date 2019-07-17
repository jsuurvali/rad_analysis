### in bash, do the following with stacks output to begin: awk 'NR > 2' populations.structure | cut -f3- > forlea.stru
setwd("E:/Dropbox/stacks2_analysis/paper1_files/3cb")
source("http://membres-timc.imag.fr/Olivier.Francois/Conversion.R")
source("http://membres-timc.imag.fr/Olivier.Francois/POPSutilities.R")
library(LEA)
library(maps)
library(mapplots)

struct2geno(file = "forlea.stru", TESS = FALSE, diploid = TRUE, FORMAT = 2,
            extra.row = 0, extra.col = 0, output = "./lea.geno")

coords = read.table("coordinates.coord", sep = "\t")
coords[,2] <- as.numeric(as.character(coords[,2]))
coords[,3] <- as.numeric(as.character(coords[,3]))
pop = as.character(coords[,1])
popmap = read.table("popmap", sep = "\t")
indv = popmap[,1]
popassign = as.character(popmap[,2])

colorlist = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0", "#F0027F", "#BF5B17", "#666666", "#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", "#A6761D", "#666666", "#A6CEE3", "#1F78B4", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4", "#FED9A6", "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2", "#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4", "#E6F5C9", "#FFF2AE", "#F1E2CC", "#CCCCCC", "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999", "#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3", "#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F")


### Entropy plots

pdf("entropy.pdf")
par(mfrow=c(3,2))
for (i in 1:10){
  mar = c(0,1,0,1)
  plot(snmf("lea.geno", K = 5:25, ploidy = 2, entropy = T, alpha = 100, project = "new"), cex = 1.4, pch = 19)
}
dev.off()

### Calculate coancestry matrices
matrices = list()
for (i in 1:19){
  matrices[[i]] <- Q(snmf("lea.geno", K = i + 1, alpha = 100, project = "new"), K = i + 1)
}

### Plot coancestry matrices

pdf("structure_2.pdf", width=20, height=20)
par(mfrow=c(19,1))
par(mar=c(1, 1, 3, 1))
par(mgp = c(0,0,0))
for (i in 1:19){
  par(las=3)
  barplot(t(matrices[[i]]), col = colorlist, border = NA, space = 0, names.arg = indv, cex.names = 0.4, main = paste("K=", i+1, sep = ""))
}
dev.off()


### Plot matrices as pie charts on a geographic map, with arbitrary coordinates for lab strains (just so that they would show up on the plot)

for (i in 1:19){
  df = data.frame(cbind(matrices[[i]], popassign))
  k = i+1
  k1 = k+1
  for (j in 1:k){
    df[,j] = as.numeric(as.character(df[,j]))
  }  
  qpop <- aggregate(df[, 1:k], list(df[,k1]), mean)[,2:k1]
  
  pdf(paste("k", k, ".pdf", sep = ""))
  plot(coords[,c(3,2)], xlim = c(70,95), ylim = c(5,30), xlab = "Longitude", ylab = "Latitude", type = "n")
  map(col = "grey95", fill = TRUE, xlim = c(70,95), ylim = c(5,30), add = TRUE)
  for (j in 1:19){add.pie(z = as.numeric(as.character(qpop[j,])), x = as.numeric(as.character(coords[j,3])), y = as.numeric(as.character(coords[j,2])), labels = "", col = colorlist)}
  dev.off()
  
  pdf(paste("k", k, ".WB.pdf", sep = ""))
  plot(coords[,c(3,2)], xlim = c(84,91), ylim = c(22,29), xlab = "Longitude", ylab = "Latitude", type = "n")
  map(col = "grey95", fill = TRUE, xlim = c(84,91), ylim = c(22,29), add = TRUE)
  for (j in 1:19){add.pie(z = as.numeric(as.character(qpop[j,])), x = as.numeric(as.character(coords[j,3])), y = as.numeric(as.character(coords[j,2])), labels = "", col = colorlist, radius = 0.3)}
  dev.off()
  
  pdf(paste("k", k, ".WBNorth.pdf", sep = ""))
  plot(coords[,c(3,2)], xlim = c(89.1,89.6), ylim = c(26.1,26.6), xlab = "Longitude", ylab = "Latitude", type = "n")
  map(col = "grey95", fill = TRUE, xlim = c(89.1,89.6), ylim = c(26.1,26.6), add = TRUE)
  for (j in 1:19){add.pie(z = as.numeric(as.character(qpop[j,])), x = as.numeric(as.character(coords[j,3])), y = as.numeric(as.character(coords[j,2])), labels = "", col = colorlist, radius = 0.02)}
  dev.off()
  
  pdf(paste("k", k, ".WBSouth.pdf", sep = ""))
  plot(coords[,c(3,2)], xlim = c(84,89), ylim = c(20,25), xlab = "Longitude", ylab = "Latitude", type = "n")
  map(col = "grey95", fill = TRUE, xlim = c(84,89), ylim = c(20,25), add = TRUE)
  for (j in 1:19){add.pie(z = as.numeric(as.character(qpop[j,])), x = as.numeric(as.character(coords[j,3])), y = as.numeric(as.character(coords[j,2])), labels = "", col = colorlist, radius = 0.2)}
  dev.off()
}


for (i in 15:19){
  dfdat <- snmf.pvalues(snmf("lea.geno", K = i, ploidy = 2, entropy = T, alpha = 100, project = "new"), entropy = TRUE, ploidy = 2, K = i)
  assign(paste("pdat",i,sep = ""), dfdat$pvalues)
}

