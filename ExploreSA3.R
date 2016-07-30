packages <- c("dplyr", "htmlwidgets", "httr")



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
  Nr_Buis_Utilities = as.numeric(`Electricity,Gas,WaterandWasteServices(countofbusinesses)`),     
  Nr_Buis_PublicAdmin = as.numeric(`PublicAdministrationandSafety(countofbusinesses)`),              
  Nr_Buis_Education = as.numeric(`EducationandTraining(countofbusinesses)`),                       
  Nr_Buis_Mining = as.numeric(`Mining(countofbusinesses)`),   
  Nr_Buis_Tech = as.numeric(`Professional,ScientificandTechnicalServices(countofbusinesses)`),
  Nr_Buis_Hospitality = as.numeric(`AccommodationandFoodServices(countofbusinesses)`), 
  Nr_Buis_Arts = as.numeric(`ArtsandRecreationServices(countofbusinesses)`),                  
  Nr_Buis_Construction = as.numeric(`Construction(countofbusinesses)`),                                                       
  Nr_Buis_Retail = as.numeric(`RetailTrade(countofbusinesses)`),                                
  Nr_Buis_Topindustry = as.numeric(`Topindustry(bycountofbusinesses)`), 
  Nr_Buis_RealEstate = as.numeric(`Rental,HiringandRealEstateServices(countofbusinesses)`),   
  Nr_Buis_Media = as.numeric(`InformationMediaandTelecommunications(countofbusinesses)`),      
  Nr_Buis_Logisitcs = as.numeric(`Transport,PostalandWarehousing(countofbusinesses)`),
  Nr_Buis_Admin = as.numeric(`AdministrativeandSupportServices(countofbusinesses)`),              
  Nr_Buis_Agriculture = as.numeric(`Agriculture,ForestryandFishing(countofbusinesses)`),                              
  Nr_Buis_Trade = as.numeric(`WholesaleTrade(countofbusinesses)`),                             
  Nr_Buis_Finance = as.numeric(`FinancialandInsuranceServices(countofbusinesses)`),                                                  
  Nr_Buis_Health = as.numeric(`HealthCareandSocialAssistance(countofbusinesses)`),              
  Nr_Buis_Manufacture = as.numeric(`Manufacturing(countofbusinesses)`)
  )