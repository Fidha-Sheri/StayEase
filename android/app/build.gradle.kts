plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter plugin (MUST be after android + kotlin)
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 Firebase Google Services plugin
    id("com.google.gms.google-services")
}

android {
    // ⚠️ MUST MATCH google-services.json package_name
    namespace = "com.example.my_app"

    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_app"

        // 🔥 Firebase requires minSdk 21+
        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Debug signing for now
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Firebase BOM (manages versions automatically)
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // 🔐 Firebase Authentication
    implementation("com.google.firebase:firebase-auth")

    // 🗄️ Cloud Firestore
    implementation("com.google.firebase:firebase-firestore")
}
