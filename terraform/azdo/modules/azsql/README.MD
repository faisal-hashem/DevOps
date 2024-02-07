# Introduction 
  * The files in this directory collectively build everything necessary for a generic Azure SQL deployment.
  * These files are temporarily here as a "local" module for ease of testing and iteration.  Ultimately, this entire directory will be moved to the Terraform_Modules repo.
  * NOTE: The DB team has not yet been engaged to determine the optimal parameters for an Azure SQL deployment.

# Directory and File Structure
  * I (Brett) have used my preferred module syntax for the files in the this folder.
  * azsql.tf does all the deployment work
  * azsqlVARS.tf declares all the variables needed for this module
  * azsqlOUTPUT.tf outputs all the values that might be needed by a calling set of code
