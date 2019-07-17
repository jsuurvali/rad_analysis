setwd("~/Dropbox/stacks2_analysis/paper1_files/3cb")
library(data.table)
library(ggplot2)
library(ggExtra)
library(gridExtra)

dfdat=fread("populations.sumstats.tsv", header = T, skip = 13, sep = "\t")[,c(5,9)]
colnames(dfdat) <- c("pop_id", "freq")
dfdat$pop_id <- ifelse(dfdat$pop_id == "TU", "TU_2014", dfdat$pop_id)
dfdat$pop_id <- ifelse(dfdat$pop_id == "TU2018", "TU_2018", dfdat$pop_id)
dfdat$pop_id <- ifelse(dfdat$pop_id == "WIK", "WIK_2014", dfdat$pop_id)
dfdat$pop_id <- ifelse(dfdat$pop_id == "WIK2018", "WIK_2018", dfdat$pop_id)
dfdat = dfdat[dfdat$freq != 0 & dfdat$freq != 1,]

pops = as.character(sort(unique(dfdat$pop_id)))


df <- dfdat
results = list()

df$freq <- as.double(lapply(df$freq, function(x) 1 - ceiling(10*x) / 10))

for (i in pops){
  tmp1 = as.data.frame(table(df[df$pop_id == i, 2]))
  tmp1$Freq=tmp1$Freq/sum(tmp1$Freq)
  results[[i]] <- ggplot(tmp1, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme_bw() +
    xlab("Derived allele frequency") +
    ylab("Proportion") +
    ggtitle(i) +
    theme(text=element_text(size=8)) +
    theme(axis.text.x = element_text(color = "black", angle = 90)) +
    removeGrid() +
    ylim(0,0.5)
}
pdf("daf.pdf")
grid.arrange(results[[1]],results[[2]],results[[3]],results[[4]],results[[5]],results[[6]],results[[7]], results[[8]],results[[9]],results[[10]],results[[11]],results[[12]],results[[13]], ncol = 4, nrow = 4)
dev.off()



df <- dfdat
results = list()

df$freq <- ifelse(df$freq > 0.5, 1-df$freq, df$freq)
df$freq <- as.double(lapply(df$freq, function(x) floor(10*x) / 10))
df$freq <- ifelse(df$freq == 0.5, 0.4, df$freq)


for (i in pops){
  tmp1 = as.data.frame(table(df[df$pop_id == i, 2]))
  tmp1$Freq=tmp1$Freq/sum(tmp1$Freq)
  results[[i]] <- ggplot(tmp1, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme_bw() +
    xlab("Folded allele frequency") +
    ylab("Proportion") +
    ggtitle(i) +
    theme(text=element_text(size=8)) +
    theme(axis.text.x = element_text(color = "black", angle = 90)) +
    removeGrid() +
    ylim(0,1)
}
pdf("faf.pdf")
grid.arrange(results[[1]],results[[2]],results[[3]],results[[4]],results[[5]],results[[6]],results[[7]], results[[8]],results[[9]],results[[10]],results[[11]],results[[12]],results[[13]], ncol = 4, nrow = 4)
dev.off()