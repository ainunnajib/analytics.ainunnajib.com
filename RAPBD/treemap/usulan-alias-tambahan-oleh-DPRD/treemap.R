library(data.table)
library(googleVis)

treemapdata <- DPRD.Pemprov[SKPD.Pemprov == "N/A" & DPRD.Pagu == 0 & DPRD.HasilPembahasan != 0, 
                            .(Komisi.DPRD, SKPD.DPRD, MataAnggaran, 
                              DPRD.HasilPembahasan = DPRD.HasilPembahasan)]
treemapdata[ , MataAnggaran := paste(MataAnggaran, 1:.N), by = MataAnggaran]
treemapdata[ , Komisi.DPRD := paste("DPRD Komisi", Komisi.DPRD)]

root <- data.table("Parent" = NA, 
                   "Child" = "TOTAL : Rp 10.553.071.000.000", 
                   "Jumlah" = sum(treemapdata$DPRD.HasilPembahasan))

top <- treemapdata[ , .(sum = sum(DPRD.HasilPembahasan)), 
                    by = .(Komisi.DPRD)]
top <- cbind("TOTAL : Rp 10.553.071.000.000", top)
setnames(top, c("Parent", "Child", "Jumlah"))
top[ , Child := paste(Child, ":", "Rp", 
                      format(Jumlah, scientific = FALSE, trim = TRUE, 
                             big.mark = "."))]

Komisi.SKPD <- treemapdata[ , .(sum = sum(DPRD.HasilPembahasan)), 
                           by = .(Komisi.DPRD, SKPD.DPRD)]
setnames(Komisi.SKPD, c("Parent", "Child", "Jumlah"))
Komisi.SKPD[ , Child := paste(Child, ":", "Rp", 
                              format(Jumlah, scientific = FALSE, trim = TRUE, 
                                     big.mark = "."))]
Komisi.SKPD[ , Parent := paste(Parent, ":", "Rp", 
                               format(sum(Jumlah), scientific = FALSE, trim = TRUE, 
                                      big.mark = ".")),
            by = Parent]

SKPD.MataAnggaran <- treemapdata[ , .(sum = sum(DPRD.HasilPembahasan)), 
                                 by = .(SKPD.DPRD, MataAnggaran)]
setnames(SKPD.MataAnggaran, c("Parent", "Child", "Jumlah"))
SKPD.MataAnggaran[ , Child := paste(Child, ":", "Rp", 
                                     format(Jumlah, scientific = FALSE, trim = TRUE, 
                                            big.mark = "."))]
SKPD.MataAnggaran[ , Parent := paste(Parent, ":", "Rp", 
                                     format(sum(Jumlah), scientific = FALSE, trim = TRUE, 
                                            big.mark = ".")),
                  by = Parent]

MataAnggaran <- treemapdata[ , .(sum = sum(DPRD.HasilPembahasan)), 
                            by = .(MataAnggaran)]
setnames(MataAnggaran, c("Parent", "Jumlah"))
MataAnggaran[ , Child := paste("##", Parent, ":", "Rp", 
                               format(Jumlah, scientific = FALSE, trim = TRUE, 
                                      big.mark = "."), "##")]
MataAnggaran <- MataAnggaran[ , .(Parent, Child, Jumlah)]
MataAnggaran[ , Parent := paste(Parent, ":", "Rp", 
                                format(sum(Jumlah), scientific = FALSE, trim = TRUE, 
                                       big.mark = ".")),
             by = Parent]

treemapdt <- rbind(root, top, Komisi.SKPD, SKPD.MataAnggaran, MataAnggaran)
treemapdt[ , log := log(Jumlah)]

treemapUsulan <- gvisTreeMap(treemapdt, idvar = "Child", parentvar = "Parent", 
                             sizevar = "Jumlah", colorvar = "log",
                             options=list(showScale=TRUE, width=1200, height=600))

# Display chart
plot(treemapUsulan) 
# Create Google Gadget
cat(createGoogleGadget(treemapUsulan), file="treemapUsulan.xml")
save(treemapUsulan, file = "treemapUsulan.RData")
