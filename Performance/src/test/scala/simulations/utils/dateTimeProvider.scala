package utils

import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter

object DateTimeProvider {

    def getCurrentDateTime : String = 
    {
        val now = OffsetDateTime.now()
        val formatter = DateTimeFormatter.ISO_DATE_TIME
        return formatter.format(now)
    }
}