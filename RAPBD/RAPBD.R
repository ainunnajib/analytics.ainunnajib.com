library(data.table)
library(dplyr)
library(reshape2)

load("refkode.RData")

lampiran3 <- read.csv("lampiran3.csv", header = T, sep = "|", 
                      quote = "", comment.char = "", colClasses = "character")
lampiran3 <- data.table(lampiran3)

lampiran3[ , Jumlah := gsub('\\.', '', Jumlah)]
lampiran3[ , Jumlah := as.numeric(Jumlah)]
lampiran3[ , Tipe := as.factor(Tipe)]
lampiran3[ , SubTipe := as.factor(SubTipe)]
lampiran3[ , PendapatanBelanja := as.factor(PendapatanBelanja)]
lampiran3[ , UrusanPemerintahan := as.factor(UrusanPemerintahan)]
lampiran3[ , Organisasi := as.factor(Organisasi)]
lampiran3[ , Program := as.factor(Program)]
lampiran3[ , SubProgram := as.factor(SubProgram)]

save(lampiran3, file = "lampiran3.RData")

rapbd <- lampiran3[ , .(KodeUP = UrusanPemerintahan,
                        KodeRekening = paste(UrusanPemerintahan, Organisasi, Program, SubProgram), 
                        Kategori = PendapatanBelanja,
                        KodeOrganisasi = paste0(UrusanPemerintahan, '.', Organisasi),
                        Tipe,
                        SubTipe,
                        Uraian,
                        Jumlah)]
rapbd[ , KodeRekening := factor(KodeRekening)]
rapbd[Kategori == 4, Kategori := "PENDAPATAN DAERAH"]
rapbd[Kategori == 5, Kategori := "BELANJA DAERAH"]
rapbd[Kategori == 6, Kategori := "PEMBIAYAAN DAERAH"]
rapbd[ , Kategori := factor(Kategori)]

anggaran <- rapbd[Kategori == "BELANJA DAERAH" & !is.na(Jumlah)]
anggaran[ , n := 1:.N, by = .(KodeRekening, Tipe, SubTipe)]
anggaran[ , KodeRekening := paste(KodeRekening, n)]
anggaran <- merge(anggaran, refkode, by = "KodeRekening")

mata.anggaran <- anggaran[SubTipe != ""]
mata.anggaran <- dcast(mata.anggaran, 
                       UrusanPemerintahan + Organisasi + Kategori + KodeRekening + Program ~ Uraian, 
                       sum, value.var = "Jumlah")
colnames(mata.anggaran) <- gsub(' ', '', colnames(mata.anggaran))
mata.anggaran <- data.table(mata.anggaran)
mata.anggaran[ , TOTAL := BELANJABARANGDANJASA + BELANJAMODAL + BELANJAPEGAWAI]

mata.anggaran[ , KodeRekening := gsub('.{2}$', '', KodeRekening)]
mata.anggaran[ , KodeRekening := as.factor(KodeRekening)]
mata.anggaran[ , Organisasi := as.factor(Organisasi)]
mata.anggaran[ , Kategori := as.factor(Kategori)]
mata.anggaran[ , Program := as.factor(Program)]

save(mata.anggaran, file = "mata.anggaran.RData")
write.table(format(mata.anggaran, scientific = FALSE, trim = TRUE, big.mark = "."), 
            file = "mata.anggaran.csv", sep = "|", quote = FALSE)
