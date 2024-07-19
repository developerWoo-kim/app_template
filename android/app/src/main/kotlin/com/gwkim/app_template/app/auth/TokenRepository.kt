package com.gwkim.app_template.app.auth

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

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "token_repository")
class TokenRepository @Inject constructor(@ApplicationContext private val context: Context){
    companion object {
        val ACCESS_TOKEN_KEY = stringPreferencesKey("access_token")
        val REFRESH_TOKEN_KEY = stringPreferencesKey("refresh_token")
    }

    fun getPreference(key: Preferences.Key<String>): Flow<String?> {
        return context.dataStore.data.map { prefs ->
            prefs[key]
        }
    }

    suspend fun setPreference(key: Preferences.Key<String>, value: String) {
        context.dataStore.edit { prefs ->
            prefs[key] = value
        }
    }

    suspend fun removePreference(key: Preferences.Key<String>, value: String) {
        context.dataStore.edit { prefs ->
            prefs.remove(key)
        }
    }

}