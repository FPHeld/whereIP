ipgod <- read.csv('IPGOLD27072016/IPGOD.IPGOD102_PAT_APPLICANT.csv')
ipgod <- ipgod[which(!is.na(ipgod$lat)),]
ipgodapp <- read.csv('IPGOLD27072016/IPGOD.IPGOD101_PAT_SUMMARY.csv')

ipgod <- merge(ipgod, ipgodapp, by='australian_appl_no')
rm(ipgodapp);gc()
# 160242

ipgod <- ipgod[which(!is.na(ipgod$application_year)),]
ipgod_cl <- ipgod[,c(1,15,16,21)]
save(ipgod_cl, file='Robjects/ipgodcl')