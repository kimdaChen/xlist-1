import java.util.Properties

buildscript {
    val kotlin_version by extra("1.9.23")
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${kotlin_version}")
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.xlist"
    
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.xlist"
        minSdk = 21 // 确保 minSdk 至少为 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        javaCompileOptions {
            annotationProcessorOptions {
                arguments += mapOf(
                        "room.schemaLocation" to "$projectDir/schemas".toString(),
                        "room.incremental" to "true",
                        "room.expandSecretCreators" to "false"
                )
            }
        }
    }

    signingConfigs {
        create("release") {
            // You need to create a `keystore.properties` file with the following properties:
            // storeFile=path/to/your/keystore.jks
            // storePassword=your_store_password
            // keyAlias=your_key_alias
            // keyPassword=your_key_password
            val keystorePropertiesFile = rootProject.file("keystore.properties")
            if (keystorePropertiesFile.exists()) {
                val properties = Properties()
                properties.load(keystorePropertiesFile.inputStream())
                storeFile = file(properties.getProperty("storeFile"))
                storePassword = properties.getProperty("storePassword")
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.9.0")
}

flutter {
    source = "../.."
}

configurations.all {
    resolutionStrategy.force("androidx.core:core-ktx:1.9.0")
}
