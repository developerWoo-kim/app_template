package com.gwkim.app_template.driving

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "auto_driving_option")
class AutoDrivingOption @Inject constructor(@ApplicationContext private val context: Context) {
    companion object {
        private val AUTO_START_TYPE = stringPreferencesKey("auto_start_type")
        private val BEACON_ADDRESS = stringPreferencesKey("beacon_address")
        private val DRIVING_START_CONDITION = stringPreferencesKey("driving_start_condition")
        private val DRIVING_END_CONDITION = stringPreferencesKey("driving_end_condition")
    }

    fun getAutoStartType(): Flow<String?> {
        return context.dataStore.data.map { prefs ->
            prefs[AutoDrivingOption.AUTO_START_TYPE]
        }
    }

    suspend fun saveAutoStartType(token: String) {
        context.dataStore.edit { prefs ->
            prefs[AutoDrivingOption.AUTO_START_TYPE] = token
        }
    }

    suspend fun saveAutoStartType() {
        context.dataStore.edit { prefs ->
            prefs.remove(AutoDrivingOption.AUTO_START_TYPE)
        }
    }

    fun getBeaconAddress(): Flow<String?> {
        return context.dataStore.data.map { prefs ->
            prefs[AutoDrivingOption.BEACON_ADDRESS]
        }
    }

    suspend fun saveBeaconAddress(token: String) {
        context.dataStore.edit { prefs ->
            prefs[AutoDrivingOption.BEACON_ADDRESS] = token
        }
    }

    suspend fun deleteBeaconAddress() {
        context.dataStore.edit { prefs ->
            prefs.remove(AutoDrivingOption.BEACON_ADDRESS)
        }
    }

    fun getDrivingStartCondition(): Flow<String?> {
        return context.dataStore.data.map { prefs ->
            prefs[AutoDrivingOption.DRIVING_START_CONDITION]
        }
    }

    suspend fun saveDrivingStartCondition(token: String) {
        context.dataStore.edit { prefs ->
            prefs[AutoDrivingOption.DRIVING_START_CONDITION] = token
        }
    }

    suspend fun deleteDrivingStartCondition() {
        context.dataStore.edit { prefs ->
            prefs.remove(AutoDrivingOption.DRIVING_START_CONDITION)
        }
    }

    fun getDrivingEndCondition(): Flow<String?> {
        return context.dataStore.data.map { prefs ->
            prefs[AutoDrivingOption.DRIVING_END_CONDITION]
        }
    }

    suspend fun saveDrivingEndCondition(token: String) {
        context.dataStore.edit { prefs ->
            prefs[AutoDrivingOption.DRIVING_END_CONDITION] = token
        }
    }

    suspend fun deleteDrivingEndCondition() {
        context.dataStore.edit { prefs ->
            prefs.remove(AutoDrivingOption.DRIVING_END_CONDITION)
        }
    }
}