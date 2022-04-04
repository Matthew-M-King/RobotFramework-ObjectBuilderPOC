/**
 *  This file contains the feeder which can be used to generate random number. 
 *  For now two functions are implemented - they generate 4 or 8 digits number
 *  The generated number is assign to the variable given as parameter.
 *  
 *  Usage of this object in the scenario should be: 
 *  .feed(NumberGenerator.generateFourDigits("variable_name"))
 *  or
 *  .feed(NumberGenerator.generateEightDigits("variable_name"))
 *  where "variable_name" is the name used in template.
 */

package  utils
import scala.util.Random   

object NumberGenerator { 
   
    def generateFourDigits(fieldName : String) : Iterator[scala.collection.immutable.Map[String,Int]] =
    {
       val start: Int = 1001
       val end: Int = 9999
       Iterator.continually(Map(fieldName -> (start + Random.nextInt((end - start) + 1))))
    }
    
    def generateEightDigits(fieldName : String) : Iterator[scala.collection.immutable.Map[String,Int]] =
    {
        Iterator.continually(Map(fieldName -> Random.nextInt(Integer.MAX_VALUE)))
    }
 }