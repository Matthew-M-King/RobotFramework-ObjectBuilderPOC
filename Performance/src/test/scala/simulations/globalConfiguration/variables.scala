/**  
 *  Stores variables which can be used in all tests.
 *  Takes the values set in JAVA_OPTS. If they are null, takes the default ones.
 */

package globalConfiguration

import scala.concurrent.duration._

object GlobalVariables {
    val baseUrl = System.getProperty("baseUrl", "https://petstore.octoperf.com")
    val timeout = Duration(2000, MILLISECONDS) 
    val times = Integer.getInteger("times", 10)
    val rate = Integer.getInteger("rate", 10)
    val duration =  Integer.getInteger("duration", 10)
}