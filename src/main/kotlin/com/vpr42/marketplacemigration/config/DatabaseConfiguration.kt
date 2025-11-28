package com.vpr42.marketplacemigration.config

import com.vpr42.marketplacemigration.properties.ApplicationProperties
import com.vpr42.marketplacemigration.properties.ApplicationProperties.SingleConnectionProperties
import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.flywaydb.core.Flyway
import org.flywaydb.core.api.output.MigrateResult
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class DatabaseConfiguration(
    private val applicationProperties: ApplicationProperties,
) {

    // DataSource
    @Bean
    fun devDataSource() = HikariDataSource(
        requireNotNull(applicationProperties.database[DEV]) {
            "Connection properties app.database.$DEV is null"
        }.createHikariConfig()
    )

    // Flyway
    @Bean
    fun devFlyway(devDataSource: HikariDataSource): MigrateResult = Flyway
        .configure()
        .dataSource(devDataSource)
        .locations("classpath:db/migration")
        .baselineOnMigrate(true)
        .validateOnMigrate(true)
        .outOfOrder(false)
        .placeholderReplacement(true)
        .load()
        .migrate()

    // Ручное создание конфига для DataSource
    private fun SingleConnectionProperties.createHikariConfig() = HikariConfig().apply {
        jdbcUrl = this@createHikariConfig.url
        username = this@createHikariConfig.username
        password = this@createHikariConfig.password
        driverClassName = this@createHikariConfig.driverClassName
    }

    companion object {
        private const val DEV = "dev"
    }
}
