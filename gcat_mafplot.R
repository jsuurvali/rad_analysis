setwd("E:/Dropbox/stacks2_analysis/paper1_files/3cb")
library(ggplot2)
library(gridExtra)

dfdat=read.table("withCB_GCfreqs.tsv", header = F, sep = "\t")
colnames(dfdat) <- c("pop_id", "subst", "chrom", "bp", "indv", "freq")
popsa = c("AB", "TU", "TU2018", "WIK", "WIK2018", "EKW", "Nadia", "CB", "CB1", "CB2", "CB3", "UT", "KHA", "CHT")

df=dfdat[,c(1,2,6)]
df$pop_id2 <- as.character(paste(df$pop_id, df$subst, sep = "_"))
df$freq <- as.double(lapply(as.double(as.character(df$freq)), function(x) floor(10*x) / 10))

expect <- read.table("expected2.tsv", header = T, sep = "\t")


df1 <- data.frame(Var1=1, Freq=0, Category="WS")
df2 <- data.frame(Var1=1, Freq=0, Category="SW")


results = list()
counter <- 0
for (i in popsa){
  counter <- counter + 1
  tmp1 = as.data.frame(table(df[df$pop_id == i & df$subst == "AT-GC", 3]))
  tmp2 = as.data.frame(table(df[df$pop_id == i & df$subst == "GC-AT", 3]))
  tmp1$Var1 = as.numeric(as.character(tmp1$Var1))
  tmp1$Freq = tmp1$Freq/sum(tmp1$Freq)
  tmp1$Category = "WS"
  tmp2$Var1 = as.numeric(as.character(tmp2$Var1))
  tmp2$Freq = tmp2$Freq/sum(tmp2$Freq)
  tmp2$Category = "SW"
  tmp3 <- expect[,c(1,counter+1)]
  colnames(tmp3) <- c("Var1", "Freq")
  tmp3$Category <- "SW"
  write.table(tmp1, file=paste(i,"AT-GC.freqplotdata.tsv", sep="."), row.names = F, col.names = T, sep = "\t", quote = F)
  write.table(tmp2, file=paste(i,"GC-AT.freqplotdata.tsv", sep="."), row.names = F, col.names = T, sep = "\t", quote = F)
  tmptab = rbind(tmp1, df1, tmp2, df2)
  
  results[[i]] <- ggplot(tmptab, aes(x = Var1, y = Freq, fill = Category)) +
    geom_bar(stat = "identity", position = "dodge", colour="black", lwd=0.3) +
    scale_fill_manual(values = c("coral2", "lightgrey")) +
    geom_line(data = tmp3) +
    theme_bw() +
    ylim(0,0.6) +
    xlab("Derived allele frequency") +
    ylab("Proportion") +
    ggtitle(i) +
    theme(text=element_text(size=8)) +
    theme(axis.text.x = element_text(color = "black", angle = 90)) +
    theme(legend.position = "none", axis.title.y = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
}

pdf("gBGC_allref.pdf")
grid.arrange(results[[1]], results[[2]], results[[3]], results[[4]],results[[5]],results[[6]],results[[7]],results[[8]], results[[9]], results[[10]], results[[11]], results[[12]], results[[13]], results[[14]], ncol = 4, nrow = 4)
dev.off()







chsq <- function(x){
  chisq.test(cbind(as.numeric(table(df[df$pop_id == x & df$subst == "AT-GC", 3])), as.numeric(table(df[df$pop_id == x & df$subst == "GC-AT", 3]))))
}