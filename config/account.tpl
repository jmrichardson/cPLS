# User first and last name
lc$name = "FirstName LastName"

# Email address (used to send email report)
lc$email = "user@domain.com"

# LC Account number
lc$accID = "12345627"

# API token (paste API token)
lc$token = "xxxxxxxxxxxxxxxxxxxxxxxxx";

# Maximum notes per order submission (0 for unlimited)
lc$maxNotesPerOrder = 5

# Minimum cash level to maintain in account (0 for no minimum)
lc$minCash = 0

# Lending Club Portfolio ID (FALSE for unassigned)
lc$portfolioId = FALSE

# Investment amount per note (must be multiple of 25)
lc$amountPerNote = 25

# Note sort from highest to lowest(Prioritize note selection)
# Popular fields are model and intRate
lc$sortField = 'model'

# Maximum grade allocation (comment out for no grade allocation)
lc$gradeAllocation = c("A" = 0, "B" = .20, "C" = .60, "D" = .60, "E" = .1, "F" = 0, "G" = 0)

# Maximum term allocation (comment out for no term allocation)
lc$termAllocation = c("36" = .60, "60" = .60)

# Filter Criteria
lc$filterCriteria <- function (x)  {
  filter(x,
    intRate >= 16 &
    ( grade == 'C' | grade == 'D' | grade == 'E') &
    inqLast6Mths <= 2 &
    delinq2Yrs <= 0 &
    pubRec <= 0 &
    model >= .88
  )
}

# Report criteria
lc$reportCriteria=c('id','intRate','grade','purpose','inqLast6Mths','model')

# Include portfolio in email report
lc$mailIncludePortfolio = TRUE

# Include server logs in email report
lc$mailIncludeLogs = TRUE
