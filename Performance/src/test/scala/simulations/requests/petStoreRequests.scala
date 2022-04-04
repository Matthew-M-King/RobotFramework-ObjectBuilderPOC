/**  
 *  Stores object "GetPetStoreRequest" with vals describing requests
 */
 
package requests

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import utils._
import globalConfiguration._

object PetStoreRequests{
  
  val getPetStore = exec(
      http("GetPetStore")
        .get(GlobalVariables.baseUrl + "/")
        .headers(BaseHeader.baseHeaders)
    )

  val getSignOn = exec(
      http("GetSignOn")
        .get("/actions/Account.action?signonForm=")
        .headers(BaseHeader.baseHeaders)
    )

  val postLogin = exec(
      http("PostLogin")
        .post("/actions/Account.action")
        .headers(BaseHeader.baseHeaders)
        .formParam("username", "testuser182")
        .formParam("password", "letmein")
        .formParam("signon", "Login")
        .formParam("_sourcePage", "oJ8yFRYCdA-4HGNClIGm2jsJ1YMTiOSUQFR2j78_t5Thfz7TvFLvnAekrC2AGFdP-Z3oAHFVfQnS5h6B0w1BrA21zlEZMMbQTqq6Cdw3l3Y=")
        .formParam("__fp", "Z2F64MCNtsczfucyGfpdzXRXckLVfB450cH0-48YU6ICr5vOBMYeYM62efUxe3tY")
    )

  val getAccountForm = exec(
      http("GetAccountForm")
        .get("/actions/Account.action?editAccountForm=")
        .headers(BaseHeader.baseHeaders)
    )

  val postAccountForm = exec(
    http("PostAccountForm")
        .post("/actions/Account.action")
        .headers(BaseHeader.baseHeaders)
        .formParam("password", "")
        .formParam("repeatedPassword", "")
        .formParam("account.firstName", "test")
        .formParam("account.lastName", "test")
        .formParam("account.email", "test")
        .formParam("account.phone", "test")
        .formParam("account.address1", "test")
        .formParam("account.address2", "test")
        .formParam("account.city", "test")
        .formParam("account.state", "test")
        .formParam("account.zip", "test")
        .formParam("account.country", "test")
        .formParam("account.languagePreference", "english")
        .formParam("account.favouriteCategoryId", "FISH")
        .formParam("editAccount", "Save Account Information")
        .formParam("_sourcePage", "5Ubt6Zo7g2q-sNQ_gb3tUx6faf-ecpkQMdf4gb2_A1KN1mnf4GTU9R_okchvpx7NLBriLJYtQxtbEO11se9yyfYUPTtepmHr6PlTl3Pxnz7gkD5nKRQINg==")
        .formParam("__fp", "8iNaQbfZOT09Wft4AT-QUBnjnBBvcYooWqzy5uzosZ7c8YkDVgKDYFbH850PsMHA9WyaVjmphLwUrNDZPFuEtOHGLJ-m_ubiXem-qKCulivNVRqnk-g0vrkXaGGFbe3cCW3HQ5TpQYG7qytFZb9jJrO3Gj80QMbVhI2-IOtpZXIbXIH_aI-sNTWiXp4mrkxY")
  )
}
