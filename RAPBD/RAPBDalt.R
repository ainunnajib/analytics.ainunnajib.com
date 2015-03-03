library(data.table)
library(dplyr)
library(reshape2)

data <- read.csv("RAPBDPemdaJakarta.csv", header = TRUE, colClasses = "character")
data <- data.table(data)
data[ , Jumlah := gsub('\\.', '', Jumlah)]
data[ , Jumlah := as.numeric(Jumlah)]
data[ , UrusanPemerintahan := factor(UrusanPemerintahan)]
data[ , Organisasi := factor(Organisasi)]
data[ , KodeRekening := factor(KodeRekening)]
data[ , Uraian := factor(Uraian)]

refkode <- data[ , .(KodeRekening, UrusanPemerintahan, Organisasi)]
refkode[ , n := 1:.N, by = KodeRekening]
refkode[ , KodeRekening := paste(KodeRekening, n)]

save(refkode, file = "refkode.RData")
