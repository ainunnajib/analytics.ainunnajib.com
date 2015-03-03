library(data.table)
library(dplyr)

rapbd.dprd <- read.csv("RAPBDversiDPRD.csv", header = TRUE,
                       colClasses = "character", strip.white = TRUE)
write.table(rapbd.dprd, "RAPBDversiDPRDx.csv", quote = FALSE, sep = "|")
rapbd.dprd <- read.csv("RAPBDversiDPRDx.csv", header = TRUE, sep = "|",
                       colClasses = "character", strip.white = TRUE)
rapbd.dprd$X <- NULL
rapbd.dprd <- data.table(rapbd.dprd)
rapbd.dprd[ , Pagu := as.numeric(Pagu)]
rapbd.dprd[ , Tambah := as.numeric(Tambah)]
rapbd.dprd[ , Kurang := as.numeric(Kurang)]
rapbd.dprd[ , HasilPembahasan := as.numeric(HasilPembahasan)]
rapbd.dprd[is.na(rapbd.dprd)] <- 0

rapbd.dprd <- rapbd.dprd %>% arrange(KodeOrganisasi, KodeProgram, NamaProgram)
rapbd.dprd[ , Organisasi := paste(KodeOrganisasi, NamaOrganisasi)]
rapbd.dprd[KodeProgram != "", 
           KodeProgram := gsub('^(\\d\\.\\d{2})\\.(\\d{2})\\.(\\d{3})\\.(\\d{3})$',
                               '\\1 \\3 \\2 \\4', KodeProgram)]


namaProgramDPRD <- rapbd.dprd[ , .(Program = NamaProgram)]
namaProgramAhok <- mata.anggaran[ , .(Program)]
namaProgramAhok[ , Program := as.character(Program)]
namaProgramAhok <- namaProgramAhok %>% arrange(Program)
namaProgramDPRD <- namaProgramDPRD %>% arrange(Program)

deltaPemprov <- setdiff(namaProgramAhok, namaProgramDPRD)
deltaDPRD <- setdiff(namaProgramDPRD, namaProgramAhok)
write.table(data.table(deltaDPRD), file = "adadiDPRDtiadadiPemprov.csv", 
            quote = FALSE, row.names = FALSE)
write.table(data.table(deltaPemprov), file = "adadiPemprovtiadadiDPRD.csv", 
            quote = FALSE, row.names = FALSE)

rapbd.dprd[KodeProgram == "", KodeProgram := paste(KodeOrganisasi, "xx", "xxx")]
rapbd.dprd <- rapbd.dprd[ , .(KomisiDPRD, SKPD = Organisasi, KodeRekening = KodeProgram, 
                              Program = NamaProgram, Pagu, Tambah, Kurang, HasilPembahasan)]
save(rapbd.dprd, file = "rapbd.dprd.RData")
write.table(format(rapbd.dprd, scientific = FALSE, trim = TRUE, big.mark = "."), 
            file = "rapbd.dprd.csv", sep = "|", quote = FALSE)
