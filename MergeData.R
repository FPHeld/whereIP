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
  select(Field_en, IPC_code) %>% mutate(IPC_code = str_sub(IPC_code, 1, 4)) %>% unique()

IP_Classes <- file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD104_PAT_IPC_CLASS.csv") %>%
  read_csv() %>% 
  select(AUSTRALIAN_APPL_NO, IPC_MARK_VALUE)

IP_Classes %>% 
  mutate(IPC_code = str_sub(IPC_MARK_VALUE, 1,4)) %>% 
  left_join(IP_Class_Expl) -> IP_Classes

names(IP_Classes) <- tolower(names(IP_Classes))

rm(list="IP_Class_Expl")

file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD101_PAT_SUMMARY.csv") %>%
  read_csv(col_types = "ncncccccccnnn" ) %>%
  filter((application_date)!="") %>% 
  select(-application_date) ->  IP_Details



file.path("rawdata","IPGOLD27072016", "IPGOD.IPGOD102_PAT_APPLICANT.csv") %>% 
  read_csv %>% 
  select (australian_appl_no, appln_type, cleanname, entity, lat, lon) ->  IP_Applicants

IP_Details %>% left_join(IP_Classes) -> IPGOD_data
IP_Applicants %>% left_join(IPGOD_data, by=c("australian_appl_no"="australian_appl_no")) %>%
  filter(!is.na(application_year), !is.na(lat))-> IPGOD_data_all

save(IPGOD_data_all, file=file.path("working", "IPGOD_data_all.RData"))
