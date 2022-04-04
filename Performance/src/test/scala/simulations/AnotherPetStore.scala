import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import utils._
import globalConfiguration._
import requests._

class AnotherPetStore extends Simulation {

    val httpProtocol = http
    .baseUrl(GlobalVariables.baseUrl)
  
    val scn = scenario("AnotherPetStore")
        .forever{
            exec(
                PetStoreRequests.getPetStore
            )
            .pause(1)
            .exec(
                PetStoreRequests.getSignOn
            )
            .pause(1)
            .exec(
                PetStoreRequests.postLogin,
                PetStoreRequests.getAccountForm
            )
            .pause(1)
            .exec(
                PetStoreRequests.postAccountForm
            )
        }

	setUp(
        scn.inject(
            rampUsers(5) during(10 seconds)
        )
    .protocols(httpProtocol)).maxDuration(30 seconds)
    .assertions(global.responseTime.max.lt(100))
}