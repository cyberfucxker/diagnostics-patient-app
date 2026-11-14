import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.diagnostics_patient"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.diagnostics_patient"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Google Maps key for the AndroidManifest placeholder. Provide it via
        // android/local.properties (MAPS_API_KEY=...) or -PMAPS_API_KEY=...
        val localProps = Properties()
        val localPropsFile = rootProject.file("local.properties")
        if (localPropsFile.exists()) {
            localProps.load(FileInputStream(localPropsFile))
        }
        manifestPlaceholders["mapsApiKey"] =
            (project.findProperty("MAPS_API_KEY") as String?)
                ?: localProps.getProperty("MAPS_API_KEY")
                ?: "YOUR_GOOGLE_MAPS_API_KEY"
    }

    // Release signing is optional: create android/key.properties (see
    // android/key.properties.example). Without it, release builds fall back to
    // the debug keystore so that `flutter build apk` works out of the box.
    val hasReleaseKeystore = keystorePropertiesFile.exists()
    if (hasReleaseKeystore) {
        signingConfigs {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

// Firebase: apply the Google services plugin only when the config file exists.
// Download google-services.json from your own Firebase project and place it in
// android/app/ (see android/app/google-services.json.example).
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}
