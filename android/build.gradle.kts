// android/build.gradle.kts
import com.android.build.gradle.LibraryExtension
import org.gradle.api.file.Directory
import org.gradle.kotlin.dsl.configure

/* ---------- Dépôts ---------- */
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/* ---------- Build dir partagé (Flutter) ---------- */
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

/* ---------- S’assure que :app est évalué avant les autres ---------- */
subprojects {
    project.evaluationDependsOn(":app")
}

/* ------------------------------------------------------------------
   PATCH AGP-8 : injecte un namespace dans isar_flutter_libs
   ------------------------------------------------------------------ */
subprojects {
    plugins.withId("com.android.library") {
        if (name == "isar_flutter_libs") {
            extensions.configure<LibraryExtension> {
                namespace = "com.isar_flutter_libs"
            }
        }
    }
}

/* ---------- Tâche clean ---------- */
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
