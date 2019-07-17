library(data.table)
library(ggplot2)
library(gridExtra)
library(png)
scipen=999

setwd("E:/Dropbox/stacks2_analysis/paper1_files/3cb")
dfdat = fread("populations.sumstats.tsv", sep = "\t", header = T, skip = 13)
pops <- c("AB", "TU_2014", "TU_2018", "WIK_2014", "WIK_2018", "EKW", "Nadia", "CB1", "CB2", "CB3", "UT", "KHA", "CHT")
popdata <- dfdat[, c(5,2,3,10,12)]
popdata <- popdata[order(popdata[,1], popdata[,2], popdata[,3]),]
setnames(popdata, c("pop_id", "chrom", "bp", "obshet", "exphet"))
popdata$pop_id <- ifelse(popdata$pop_id == "TU", "TU_2014", popdata$pop_id)
popdata$pop_id <- ifelse(popdata$pop_id == "TU2018", "TU_2018", popdata$pop_id)
popdata$pop_id <- ifelse(popdata$pop_id == "WIK", "WIK_2014", popdata$pop_id)
popdata$pop_id <- ifelse(popdata$pop_id == "WIK2018", "WIK_2018", popdata$pop_id)


popdata <- popdata[popdata$obshet + popdata$exphet != 0]

for (x in 1:25){
  counter=0
  results <- list()
  df = popdata[popdata$chrom == x, c(1,3:5)]
  for (p in 6) {
    for (i in pops){
      counter = counter + 1
      df_obs = df[df$pop_id==i, c(2,3)]
      df_exp = df[df$pop_id==i, c(2,4)]
      df_obs$bp = df_obs$bp/1000000
      df_exp$bp = df_exp$bp/1000000
      df_locs = data.frame(df_obs$bp, 0, stringsAsFactors = F)
      colnames(df_obs) <- c("Mb", "val")
      colnames(df_exp) <- c("Mb", "val")
      colnames(df_locs) <- c("Mb", "val")
      results[[counter]] <- ggplot(df_obs, aes(x = Mb, y = val)) +
        geom_hline(yintercept=0, linetype="dashed") +
        geom_smooth(size=1, data = df_obs, colour = "black", span = p/100, alpha=0.4, size = 10, method = "loess", formula = 'y ~ x',  se = F) +
        geom_smooth(size=1, data = df_exp, colour = "red", span = p/100, alpha=0.4, size = 10, method = "loess", formula = 'y ~ x',  se = F) +
        geom_point(data = df_locs, size = 2, colour = "darkorchid4")+
        scale_x_continuous(labels = scales::comma)+
        theme_linedraw(base_size=24) +
        ggtitle(paste(i, ", chr", x, sep = "")) + 
        theme(axis.title.y=element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
        xlim(0,80) +
        ylim(0,1)
    }
    counter=0
    tiff(paste("hetplots_loess",p/100, "_chr", x, ".", "tif", sep = ""), height = 1400, width = 900)
    grid.arrange(results[[1]],results[[2]],results[[3]],results[[4]],results[[5]],results[[6]],results[[7]], results[[8]],results[[9]],results[[10]], results[[11]],results[[12]],results[[13]], ncol = 2, nrow = 7)
    dev.off()
  }
}
