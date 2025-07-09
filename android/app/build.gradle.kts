// android/app/build.gradle.kts

fun get              (name: String): String = project.properties[name] as String

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Fix: Set the NDK version to the highest required version as per the error message.
    // This ensures compatibility with all plugins.
    ndkVersion = "27.0.12077973" // Set to the version reported in the error or higher

    // The compileSdk version should be the latest stable Android API level.
    // As of recent Flutter versions, this is often 34 or higher.
    compileSdk = 34 // Ensure this matches your Flutter setup's recommendation

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    namespace = "com.jmr.healthcare" // Your organization ID

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/tools/publishing/app-signing#secure-by-default)
        applicationId = "com.jmr.healthcare"
        minSdk = 21 // Minimum Android SDK version supported by your app
        targetSdk = 34 // Target Android SDK version
        versionCode = flutter.versionCode ?: 1
        versionName = flutter.versionName ?: "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

flutter {
    source="../.."
}

dependencies {
    // Import the Kotlin standard library.
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:1.8.0"))
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // Add AndroidX dependencies if needed for specific native features
    implementation("androidx.core:core-ktx:1.13.1") // Example: for KTX extensions
    implementation("androidx.appcompat:appcompat:1.6.1") // Example: for AppCompat
    implementation("com.google.android.material:material:1.12.0") // Example: for Material Design components

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
