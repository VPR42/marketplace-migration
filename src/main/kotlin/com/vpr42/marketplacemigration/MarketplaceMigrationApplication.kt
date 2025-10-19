package com.vpr42.marketplacemigration

import com.vpr42.marketplacemigration.properties.ApplicationProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication

@SpringBootApplication
@EnableConfigurationProperties(
    ApplicationProperties::class
)
class MarketplaceMigrationApplication

fun main(args: Array<String>) {
    runApplication<MarketplaceMigrationApplication>(*args)
}
