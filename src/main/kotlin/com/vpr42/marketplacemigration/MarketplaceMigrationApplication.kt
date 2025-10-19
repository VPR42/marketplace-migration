package com.vpr42.marketplacemigration

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MarketplaceMigrationApplication

fun main(args: Array<String>) {
    runApplication<MarketplaceMigrationApplication>(*args)
}
