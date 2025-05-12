import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // 🔥 Firebase 설정
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // 🔥 Flutter Gradle Plugin 적용
}

// ✅ key.properties 파일 로드
val keyProps = Properties()
val keyPropsFile = rootProject.file("app/key.properties")
println("🔍 key.properties 파일 경로: " + keyPropsFile.absolutePath)


if (keyPropsFile.exists()) {
    keyProps.load(keyPropsFile.inputStream())
} else {
    throw GradleException("🚨 key.properties 파일을 찾을 수 없습니다! 🚨")
}

android {
    namespace = "com.example.login_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.login_app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyStoreFilePath = keyProps["keyStoreFile"] as? String ?: throw GradleException("🚨 keyStoreFile 값이 설정되지 않았습니다!")

            val resolvedPath = rootProject.file("app/$keyStoreFilePath") // ✅ 경로 수정 및 올바른 위치 확인
            if (!resolvedPath.exists()) {
                throw GradleException("🚨 지정된 keystore 파일이 존재하지 않습니다: $resolvedPath")
            }

            println("🔍 key.properties에 설정된 키스토어 경로: $keyStoreFilePath")
            println("🔍 Gradle이 참조하는 실제 파일 경로: " + resolvedPath.absolutePath)

            storeFile = resolvedPath
            storePassword = keyProps["keyStorePassword"] as? String ?: throw GradleException("🚨 storePassword 값이 설정되지 않았습니다!")
            keyAlias = keyProps["keyAlias"] as? String ?: throw GradleException("🚨 keyAlias 값이 설정되지 않았습니다!")
            keyPassword = keyProps["keyPassword"] as? String ?: throw GradleException("🚨 keyPassword 값이 설정되지 않았습니다!")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // 🔥 ProGuard 활성화
            isShrinkResources = true // 🔥 리소스 최적화
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}