packages <- c("dplyr", "ggplot2", "readxl", "readr", "stringr")

for (i in packages){
  if (i %in% installed.packages()){
    library(i, character.only=TRUE)
  } else {
    install.packages(i) 
    library(i, character.only=TRUE)
  }
}

IP_Class_Expl <- read_excel(file.path("rawdata","ipc_technology.xls"), sheet=1, skip=6) %>% 
  select(Sector_en, IPC_code)


file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD104_PAT_IPC_CLASS.csv") %>%
  read_csv() %>% 
  select(AUSTRALIAN_APPL_NO, IPC_MARK_VALUE) -> IP_Classes

IP_Classes %>% mutate(IPC_code = 

file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD101_PAT_SUMMARY.csv") %>%
  read_csv(col_types = "ncncccccccnnn" ) %>%
  filter((application_date)!="") %>% 
  select(-application_date) ->  IP_Details



IP_Dates$application_year %>% table
#IP_Applicants <- file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD102_PAT_APPLICANT.csv"))



IP_Classes$AUSTRALIAN_APPL_NO %in% IP_Dates