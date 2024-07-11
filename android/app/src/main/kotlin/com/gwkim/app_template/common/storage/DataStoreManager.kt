package com.gwkim.app_template.common.storage

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences

object DataStoreManager {
    private lateinit var instance: DataStore<Preferences>

    fun initialize(dataStore: DataStore<Preferences>) {
        instance = dataStore
    }

    fun getDataStore(): DataStore<Preferences> {
        if (!DataStoreManager::instance.isInitialized) {
            throw IllegalStateException("DataStoreManager must be initialized first")
        }
        return instance
    }
}