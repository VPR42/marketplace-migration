package com.vpr42.marketplacemigration.properties

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "app")
data class ApplicationProperties(
    val database: Map<String, SingleConnectionProperties>
) {
    data class SingleConnectionProperties(
        val url: String,
        val username: String,
        val password: String,
        val driverClassName: String,
    )
}
