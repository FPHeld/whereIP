packages <- c("dplyr", "htmlwidgets", "httr", "tidyr", "stringr")



for (i in packages){
  if (i %in% installed.packages()){
    library(i, character.only=TRUE)
  } else {
    install.packages(i) 
    library(i, character.only=TRUE)
  }
}

latest_AS3_data_loc <- "http://data.gov.au/api/action/datastore_search?resource_id=223e2340-5c0a-4bd8-8818-e3cd2fee13c8&limit=4000"

latest_AS3_data <- jsonlite::fromJSON(latest_AS3_data_loc)$result$records

latest_AS3_data_clean <- latest_AS3_data %>% transmute(
  #Admin
  SA3_Name = SA3_Name,                                
  Longitude = as.numeric(Longitude),
  Latitude = as.numeric(Latitude), 
  Year = as.numeric(Year),
  State = State,                                                        
  Remoteness = Remoteness,
  Population = EstimatedResidentPopulation,
  #Research/Infrastructure
  Nr_Research_Inst = as.numeric(`CountofResearchInstitutes(2015)`),  
  Nr_Unis = as.numeric(`CountofUniversityCampuses(2015)`),
  Nr_TAFEs = as.numeric(`CountofTAFEs(2015)`), 
  BusiDevelopmentExpenditure = as.numeric(`AverageBusinessResearchandDevelopmentExpenditure`),  
  #Targets
  Nr_NewBusine = as.numeric(Newbusinessentries),                                            
  Nr_TM_Applicants = as.numeric(`Trademarkapplicants(total)`),
  Nr_PatentApplicants =  as.numeric(`Patentapplicants(total)`),           
  Nr_Patents_per10k =  as.numeric(`Patents(per10,000residents)`),   
  Nr_TM_Applicants_per10k = as.numeric(`Trademarkapplicants(per10,000residents)`),
  Nr_NewBusines_per10k = as.numeric(`Newbusinessentries(per10,000residents)`),                        
  #Education
  Share_Labourforce = as.numeric(`Labourforce(total)`)  / as.numeric(Population),
  Share_Unemployed = as.numeric(`Unemployed(total)`)  / as.numeric(Population),
  Share_Ed_Y12 = as.numeric(`Year12orequivalent(total,2011)`)  / as.numeric(Population),
  Share_Ed_Bachelor = as.numeric(`BachelorDegreeLevel(total,2011)`)  / as.numeric(Population), 
  Share_Ed_PG = as.numeric(`PostgraduateDegreeLevel(total,2011)`)  / as.numeric(Population), 
  Share_Ed_ADipl = as.numeric(`AdvancedDiplomaandDiplomaLevel(total,2011)`)  / as.numeric(Population),  
  Share_Ed_NoSchool = as.numeric(`Didnotgotoschool(total,2011)`)  / as.numeric(Population),  
  Share_Ed_GDip = as.numeric(`GraduateDiplomaandGraduateCertificateLevel(total,2011)`)  / as.numeric(Population), 
  Share_Ed_Cert = as.numeric(`CertificateLevel(total,2011)`)  / as.numeric(Population), 
  #Businesses
  Nr_Busi_Utilities = as.numeric(`Electricity,Gas,WaterandWasteServices(countofbusinesses)`),     
  Nr_Busi_PublicAdmin = as.numeric(`PublicAdministrationandSafety(countofbusinesses)`),              
  Nr_Busi_Education = as.numeric(`EducationandTraining(countofbusinesses)`),                       
  Nr_Busi_Mining = as.numeric(`Mining(countofbusinesses)`),   
  Nr_Busi_Tech = as.numeric(`Professional,ScientificandTechnicalServices(countofbusinesses)`),
  Nr_Busi_Hospitality = as.numeric(`AccommodationandFoodServices(countofbusinesses)`), 
  Nr_Busi_Arts = as.numeric(`ArtsandRecreationServices(countofbusinesses)`),                  
  Nr_Busi_Construction = as.numeric(`Construction(countofbusinesses)`),                                                       
  Nr_Busi_Retail = as.numeric(`RetailTrade(countofbusinesses)`),                                
  Nr_Busi_Topindustry = as.numeric(`Topindustry(bycountofbusinesses)`), 
  Nr_Busi_RealEstate = as.numeric(`Rental,HiringandRealEstateServices(countofbusinesses)`),   
  Nr_Busi_Media = as.numeric(`InformationMediaandTelecommunications(countofbusinesses)`),      
  Nr_Busi_Logisitcs = as.numeric(`Transport,PostalandWarehousing(countofbusinesses)`),
  Nr_Busi_Admin = as.numeric(`AdministrativeandSupportServices(countofbusinesses)`),              
  Nr_Busi_Agriculture = as.numeric(`Agriculture,ForestryandFishing(countofbusinesses)`),                              
  Nr_Busi_Trade = as.numeric(`WholesaleTrade(countofbusinesses)`),                             
  Nr_Busi_Finance = as.numeric(`FinancialandInsuranceServices(countofbusinesses)`),                                                  
  Nr_Busi_Health = as.numeric(`HealthCareandSocialAssistance(countofbusinesses)`),              
  Nr_Busi_Manufacture = as.numeric(`Manufacturing(countofbusinesses)`)
  )

latest_AS3_data_clean %>% 
  select(SA3_Name, Year, contains("Nr_Busi")) %>%
  gather(key, Nr_Busi, contains("Nr_Busi")) %>% 
  mutate(Type=str_sub(key, 9, -1)) -> latest_AS3_data_BusiCount
  
latest_AS3_data_clean %>%
    filter(Year==2011) %>%
    select(SA3_Name, contains("Share_Ed")) %>%
    gather(key, Share_Ed, contains("Share_Ed")) %>%
    mutate(Education=str_sub(key, 10, -1)) -> latest_AS3_data_2011_EdLevel


latest_AS3_data_clean %>%
  select( SA3_Name, Year, Nr_NewBusine, Nr_TM_Applicants, Nr_PatentApplicants, 
          Nr_Patents_per10k, Nr_TM_Applicants_per10k, Nr_NewBusines_per10k) %>%
  left_join(latest_AS3_data_2011_EdLevel, 
            by=c("SA3_Name"="SA3_Name")) %>%
  left_join(latest_AS3_data_BusiCount, 
            by=c("SA3_Name"="SA3_Name", 
                 "Year"="Year") ) %>%
  select(-key.x, -key.y) -> latest_AS3_data_BusiDEmPerf
    
# 
# #Education
# Share_Labourforce = as.numeric(`Labourforce(total)`)  / as.numeric(Population),
# Share_Unemployed = as.numeric(`Unemployed(total)`)  / as.numeric(Population),


latest_AS3_data_clean %>% 
  select(Year, SA3_Name, State, Remoteness, Nr_NewBusine:Nr_NewBusines_per10k) -> AS3_data_for_Trends
Trend_Y_choices <- names(AS3_data_for_Trends)[5:10]
