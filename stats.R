# Process LC statistics

options(scipen=999)

# Load libraries
library('plyr')
library('dplyr')
library('lubridate')
library('stringr')
library('data.table')

# Function to set relative home directory (requires latest Rstudio)
defaultDir = '/home/user/cpls'
csf <- function() {
  cmdArgs = commandArgs(trailingOnly = FALSE)
  needle = "--file="
  match = grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript via command line
    return(normalizePath(sub(needle, "", cmdArgs[match])))
  } else {
    ls_vars = ls(sys.frames()[[1]])
    if ("fileName" %in% ls_vars) {
      # Source'd via RStudio
      return(normalizePath(sys.frames()[[1]]$fileName)) 
    } else {
      if (!is.null(sys.frames()[[1]]$ofile)) {
        # Source'd via R console
        return(normalizePath(sys.frames()[[1]]$ofile))
      } else {
        # RStudio Run Selection
        return(normalizePath(rstudioapi::getActiveDocumentContext()$path))
      }
    }
  }
}
dir <- tryCatch(dirname(csf()),
  error = function(e) {
    defaultDir
  }
)
if (is.null(dir) | length(dir) == 0) {
  dir <- defaultDir
}
if(!dir.exists(dir)) {
  err('Unable to determine home directory')
} else {
  setwd(dir)
}

# Set seed for model comparisons
set.seed(1)

# Location of LC statistics stats
statsDir <- 'C:/temp'
# statsDir <- '/var/tmp'


# Read in Lending Club statistics
stats1=read.csv(paste(statsDir,'LoanStats3a_securev1.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats1 <- stats1[!is.na(stats1$loan_amnt),]
stats1$id=as.integer(as.character(stats1$id))

stats2=read.csv(paste(statsDir,'LoanStats3b_securev1.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats2 <- stats2[!is.na(stats2$loan_amnt),]
stats2$id=as.integer(as.character(stats2$id))

stats3=read.csv(paste(statsDir,'LoanStats3c_securev1.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats3 <- stats3[!is.na(stats3$loan_amnt),]
stats3$id=as.integer(as.character(stats3$id))

stats4=read.csv(paste(statsDir,'LoanStats3d_securev1.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats4 <- stats4[!is.na(stats4$loan_amnt),]
stats4$id=as.integer(as.character(stats4$id))

stats5=read.csv(paste(statsDir,'LoanStats_securev1_2016Q1.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats5 <- stats5[!is.na(stats5$loan_amnt),]
stats5$id <- as.integer(as.character(stats5$id))

stats6=read.csv(paste(statsDir,'LoanStats_securev1_2016Q2.csv',sep='/'),na.strings=c(""," ","NA"),header=TRUE,skip=1)
stats6 <- stats6[!is.na(stats6$loan_amnt),]
stats6$id=as.integer(as.character(stats6$id))

# Update field name
names(stats1)[names(stats1)=="is_inc_v"] <- "verification_status"
names(stats2)[names(stats2)=="is_inc_v"] <- "verification_status"

# # Verify classes are the same for fields before merging
# for (name in names(stats6)) {
#   classes <- c(class(stats1[[name]]),class(stats2[[name]]),class(stats3[[name]]),class(stats4[[name]]),class(stats5[[name]]),class(stats6[[name]]))
#   if (length(unique(classes))>1) {
#     print(name)
#     print(classes)
#   }
# }

# df=merge(stats1,stats2,all=T)
# df=merge(df,stats3,all=T)
# df=merge(df,stats4,all=T)
# stats=merge(df,stats5,all=T)
# stats <- smartbind(stats1,stats2)

# Combine all LC stats into one stats frame
stats <- rbind.fill(list(stats6,stats5,stats4,stats3,stats2,stats1))
# stats <- data.table::rbindlist(list(stats1,stats2,stats3,stats4,stats5,stats6),fill = TRUE)


# Rename columns to match LC API
names(stats)[names(stats)=="loan_amnt"] <- "loanAmount"
names(stats)[names(stats)=="int_rate"] <- "intRate"
names(stats)[names(stats)=="sub_grade"] <- "subGrade"
names(stats)[names(stats)=="emp_title"] <- "empTitle"
names(stats)[names(stats)=="emp_length"] <- "empLength"
names(stats)[names(stats)=="home_ownership"] <- "homeOwnership"
names(stats)[names(stats)=="annual_inc"] <- "annualInc"
names(stats)[names(stats)=="zip_code"] <- "addrZip"
names(stats)[names(stats)=="addr_state"] <- "addrState"
names(stats)[names(stats)=="delinq_2yrs"] <- "delinq2Yrs"
names(stats)[names(stats)=="earliest_cr_line"] <- "earliestCrLine"
names(stats)[names(stats)=="fico_range_low"] <- "ficoRangeLow"
names(stats)[names(stats)=="fico_range_high"] <- "ficoRangeHigh"
names(stats)[names(stats)=="inq_last_6mths"] <- "inqLast6Mths"
names(stats)[names(stats)=="mths_since_last_delinq"] <- "mthsSinceLastDelinq"
names(stats)[names(stats)=="mths_since_last_record"] <- "mthsSinceLastRecord"
names(stats)[names(stats)=="open_acc"] <- "openAcc"
names(stats)[names(stats)=="pub_rec"] <- "pubRec"
names(stats)[names(stats)=="revol_bal"] <- "revolBal"
names(stats)[names(stats)=="revol_util"] <- "revolUtil"
names(stats)[names(stats)=="total_acc"] <- "totalAcc"
names(stats)[names(stats)=="mths_since_last_major_derog"] <- "mthsSinceLastMajorDerog"
names(stats)[names(stats)=="verification_status"] <- "isIncV"
names(stats)[names(stats)=="initial_list_status"] <- "initialListStatus"
names(stats)[names(stats)=="collections_12_mths_ex_med"] <- "collections12MthsExMed"
names(stats)[names(stats)=="inq_last_12m"] <- "inqLast12m"
names(stats)[names(stats)=="total_cu_tl"] <- "totalCuTl"
names(stats)[names(stats)=="inq_fi"] <- "inqFi"
names(stats)[names(stats)=="max_bal_bc"] <- "maxBalBc"
names(stats)[names(stats)=="open_rv_24m"] <- "openRv24m"
names(stats)[names(stats)=="open_rv_12m"] <- "openRv12m"
names(stats)[names(stats)=="il_util"] <- "iLUtil"
names(stats)[names(stats)=="total_bal_il"] <- "totalBalIl"
names(stats)[names(stats)=="mths_since_rcnt_il"] <- "mthsSinceRcntIl"
names(stats)[names(stats)=="open_il_24m"] <- "openIl24m"
names(stats)[names(stats)=="open_il_12m"] <- "openIl12m"
names(stats)[names(stats)=="open_il_6m"] <- "openIl6m"
names(stats)[names(stats)=="open_acc_6m"] <- "openAcc6m"
names(stats)[names(stats)=="verification_status_joint"] <- "isIncVJoint"
names(stats)[names(stats)=="dti_joint"] <- "dtiJoint"
names(stats)[names(stats)=="annual_inc_joint"] <- "annualIncJoint"
names(stats)[names(stats)=="application_type"] <- "applicationType"
names(stats)[names(stats)=="tot_coll_amt"] <- "totCollAmt"
names(stats)[names(stats)=="num_op_rev_tl"] <- "numOpRevTl"
names(stats)[names(stats)=="num_rev_tl_bal_gt_0"] <- "numRevTlBalGt0"
names(stats)[names(stats)=="total_rev_hi_lim"] <- "totalRevHiLim"
names(stats)[names(stats)=="mo_sin_rcnt_rev_tl_op"] <- "moSinRcntRevTlOp"
names(stats)[names(stats)=="mo_sin_old_rev_tl_op"] <- "moSinOldRevTlOp"
names(stats)[names(stats)=="num_actv_rev_tl"] <- "numActvRevTl"
names(stats)[names(stats)=="mo_sin_old_il_acct"] <- "moSinOldIlAcct"
names(stats)[names(stats)=="num_il_tl"] <- "numIlTl"
names(stats)[names(stats)=="num_tl_120dpd_2m"] <- "numTl120dpd2m"
names(stats)[names(stats)=="num_tl_30dpd"] <- "numTl30dpd"
names(stats)[names(stats)=="num_tl_90g_dpd_24m"] <- "numTl90gDpd24m"
names(stats)[names(stats)=="pct_tl_nvr_dlq"] <- "pctTlNvrDlq"
names(stats)[names(stats)=="num_bc_sats"] <- "numBcSats"
names(stats)[names(stats)=="num_actv_bc_tl"] <- "numActvBcTl"
names(stats)[names(stats)=="num_bc_tl"] <- "numBcTl"
names(stats)[names(stats)=="avg_cur_bal"] <- "avgCurBal"
names(stats)[names(stats)=="tot_cur_bal"] <- "totCurBal"
names(stats)[names(stats)=="tot_hi_cred_lim"] <- "totHiCredLim"
names(stats)[names(stats)=="mo_sin_rcnt_tl"] <- "moSinRcntTl"
names(stats)[names(stats)=="num_tl_op_past_12m"] <- "numTlOpPast12m"
names(stats)[names(stats)=="num_sats"] <- "numSats"
names(stats)[names(stats)=="mthsSinceLastMajorDerog"] <- "mthsSinceLastMajorDerog"
names(stats)[names(stats)=="tax_liens"] <- "taxLiens"
names(stats)[names(stats)=="collections12MthsExMed"] <- "collections12MthsExMed"
names(stats)[names(stats)=="chargeoff_within_12_mths"] <- "chargeoffWithin12Mths"
names(stats)[names(stats)=="num_accts_ever_120_pd"] <- "numAcctsEver120Ppd"
names(stats)[names(stats)=="pub_rec_bankruptcies"] <- "pubRecBankruptcies"
names(stats)[names(stats)=="mths_since_recent_bc_dlq"] <- "mthsSinceRecentBcDlq"
names(stats)[names(stats)=="num_rev_accts"] <- "numRevAccts"
names(stats)[names(stats)=="total_il_high_credit_limit"] <- "totalIlHighCreditLimit"
names(stats)[names(stats)=="total_bc_limit"] <- "totalBcLimit"
names(stats)[names(stats)=="total_bal_ex_mort"] <- "totalBalExMort"
names(stats)[names(stats)=="percent_bc_gt_75"] <- "percentBcGt75"
names(stats)[names(stats)=="mths_since_recent_revol_delinq"] <- "mthsSinceRecentRevolDelinq"
names(stats)[names(stats)=="mths_since_recent_inq"] <- "mthsSinceRecentInq"
names(stats)[names(stats)=="mths_since_recent_bc"] <- "mthsSinceRecentBc"
names(stats)[names(stats)=="mort_acc"] <- "mortAcc"
names(stats)[names(stats)=="bc_util"] <- "bcUtil"
names(stats)[names(stats)=="bc_open_to_buy"] <- "bcOpenToBuy"
names(stats)[names(stats)=="acc_open_past_24mths"] <- "accOpenPast24Mths"
names(stats)[names(stats)=="acc_now_delinq"] <- "accNowDelinq"
names(stats)[names(stats)=="funded_amnt"] <- "fundedAmount"
names(stats)[names(stats)=="member_id"] <- "memberId"
names(stats)[names(stats)=="delinq_amnt"] <- "delinqAmnt"
names(stats)[names(stats)=="all_util"] <- "allUtil"

# stats cleansing and engineering
stats$empLength=suppressWarnings(as.integer(as.character(revalue(stats$empLength,c("< 1 year"="0", "1 year"="12", "10+ years"="120", 
  "2 years"="24", "3 years"="36", "4 years"="48", "5 years"="60", "6 years"="72", 
  "7 years"="84", "8 years"="96", "9 years"="108")))))
stats$revolUtil <-as.numeric(as.character(gsub("%", "", stats$revolUtil)))
stats$isIncV=as.factor(toupper(gsub(" ", '_', stats$isIncV)))
stats$annualInc=round(stats$annualInc)
stats$initialListStatus=as.factor(toupper(stats$initialListStatus))
stats$revolBal <- as.numeric(stats$revolBal)

stats$issue_d=as.Date(format(strptime(paste("01", stats$issue_d, sep = "-"), format = "%d-%b-%Y"), "%Y-%m-%d"))
stats$last_pymnt_d=as.Date(format(strptime(paste("01", stats$last_pymnt_d, sep = "-"), format = "%d-%b-%Y"), "%Y-%m-%d"))

stats$term <-as.integer(as.character(gsub(" months", "", stats$term)))
stats$intRate <-as.numeric(as.character(gsub("%", "", stats$intRate)))

stats$earliestCrLine <- as.Date(format(strptime(paste("01", stats$earliestCrLine, sep = "-"), format = "%d-%b-%Y"), "%Y-%m-%d"))
stats$n=ymd(Sys.Date())
stats$earliestCrLineMonths=as.integer(round((stats$n - stats$earliestCrLine)/30.4375)-1)
stats$n=NULL
stats$amountTerm <- stats$loanAmount/stats$term
stats$amountTermIncomeRatio=ifelse(stats$annualInc!=0,stats$amountTerm/(stats$annualInc/12),NA)
stats$revolBalAnnualIncRatio=ifelse(stats$annualInc!=0,stats$revolBal/stats$annualInc,NA)

# Ensure factors are properly formated similar to API responses
stats$isIncVJoint <- as.factor(gsub(' ','_',toupper(stats$isIncVJoint)))

# Add in zip code stats
source('scripts/zip.R')
stats <- merge(x=stats,y=zip,by="addrZip",all.x=TRUE)

# # Add in FRED stats
# source('fred.R')
# stats <- merge(x=stats,y=allFred,by="issue_d",all.x=TRUE)

# Add binary label
stats$label <- ifelse(stats$loan_status=='Fully Paid',1,0)

# Maturity
stats$complete <- ifelse(stats$issue_d %m+% months(stats$term) <= as.Date(now()),TRUE,FALSE)

# Set predicted class as fully paid for all notes (used in tool)
stats$class <- as.factor('Fully Paid')
levels(stats$class) <- c('Fully Paid','Charged Off')
stats$class <- factor(stats$class,c('Charged Off','Fully Paid'))

# Get age of loan based on last payment
aolDays <- ifelse(stats$loan_status == 'Fully Paid',
  as.numeric(difftime(stats$last_pymnt_d,stats$issue_d,units="days")),
  ifelse(stats$loan_status == 'Charged Off',
    ifelse(is.na(stats$last_pymnt_d),
      150,
      as.numeric(difftime(stats$last_pymnt_d + months(5),stats$issue_d,units="days"))),
    as.numeric(difftime(now(),stats$issue_d,units="days"))
  ))
stats$aol=round(aolDays/30)

# As data table
stats <- as.data.table(stats)
setkey(stats,id)

# Save historical stats
save(stats,file='data/stats.rda')

###----------------------------------------------------

# Load payment history file
ph <- fread(paste(statsDir,"/",'PMTHIST_all_20160715.csv',sep=''))

# rename column
ph <- rename(ph,id=LOAN_ID)
ph <- rename(ph,Principal=PBAL_BEG_PERIOD)
ph <- rename(ph,Month=MONTH)
ph <- rename(ph,Payment=RECEIVED_AMT)

# Convert date format
ph$Month <- dmy(paste("01", ph$Month , sep =""))

# Set key for performance
setkey(ph,id)

# Select required columns for ROI tool
ph <- ph[,.(id,Month,Principal,Payment)]

# Save abbreviated payment history
save(ph,file='data/phMin.rda')


