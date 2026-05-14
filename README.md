# 🥋 Karate 2.0.7 Demo Project

Proyecto de demostración completo para aprender **Karate v2** con **Java 21+** y **Maven**.
Usa la API pública [JSONPlaceholder](https://jsonplaceholder.typicode.com) — sin configuración de servidor.

---

## ⚡ Inicio Rápido

```bash
# Clonar / descomprimir el proyecto
cd karate-demo

# Ejecutar TODOS los tests
mvn test

# Ver reporte HTML
open target/karate-reports/karate-summary.html
```

---

## 📋 Prerequisitos

| Herramienta | Versión mínima | Notas |
|-------------|---------------|-------|
| Java JDK    | **21**        | Karate v2 requiere Java 21+ para Virtual Threads |
| Maven       | 3.8+          | |
| Internet    | Requerido     | La API JSONPlaceholder es online |

```bash
# Verificar versiones
java -version   # debe mostrar 21 o superior (Java 26 también funciona)
mvn -version
```

---

## 🗂️ Estructura del Proyecto

```
karate-demo/
├── pom.xml                                    # Configuración Maven
└── src/test/java/
    ├── karate-config.js                       # ⚙️  Config global (entornos, headers, etc.)
    ├── logback-test.xml                       # 📋 Config de logging
    ├── TestRunner.java                        # 🚀 Runner principal (todos los tests)
    │
    ├── users/                                 # 👤 Dominio: Usuarios
    │   ├── users.feature                      #    Tests GET, schema validation, data-driven
    │   └── UsersRunner.java                   #    Runner individual
    │
    ├── products/                              # 📦 Dominio: Posts/Productos
    │   ├── posts.feature                      #    Tests GET, POST, PUT, PATCH, DELETE
    │   └── PostsRunner.java                   #    Runner individual
    │
    ├── auth/                                  # 🔐 Dominio: Autenticación
    │   ├── auth.feature                       #    Headers, Bearer tokens, auth flows
    │   └── AuthRunner.java                    #    Runner individual
    │
    └── common/                                # 🔧 Utilidades compartidas
        ├── api-helpers.feature                #    Callable features reutilizables
        └── test-data.json                     #    Datos de prueba centralizados
```

---

## ▶️ Comandos de Ejecución

```bash
# Todos los tests (paralelo con Virtual Threads)
mvn test

# Solo un dominio específico
mvn test -Dtest=UsersRunner
mvn test -Dtest=PostsRunner
mvn test -Dtest=AuthRunner

# Por tag
mvn test -Dkarate.options="--tags @smoke"
mvn test -Dkarate.options="--tags @regression"
mvn test -Dkarate.options="--tags @e2e"

# Por entorno
mvn test -Dkarate.env=staging
mvn test -Dkarate.env=prod

# Combinar tag + entorno
mvn test -Dtest=UsersRunner -Dkarate.env=staging -Dkarate.options="--tags @smoke"
```

---

## 🏷️ Tags disponibles

| Tag | Descripción |
|-----|-------------|
| `@smoke` | Tests críticos, ejecución rápida |
| `@regression` | Suite completa de regresión |
| `@e2e` | Flujos end-to-end completos |
| `@users` | Tests del dominio usuarios |
| `@posts` | Tests del dominio posts |
| `@auth` | Tests de autenticación |
| `@ignore` | Helpers/utilities (no ejecutar directamente) |

---

## 🔄 Migración desde v1.5.2

| Elemento | v1.5.2 | v2.0.7 |
|----------|--------|--------|
| `groupId` en pom.xml | `com.intuit.karate` | `io.karatelabs` |
| Java mínimo | Java 17 | **Java 21** |
| Motor JS | GraalJS | karate-js (propio) |
| Logger package | `com.intuit.karate` | `io.karatelabs` |
| Imports Java API | `com.intuit.karate.*` | Igual (shims de compatibilidad) |
| Sintaxis .feature | Sin cambios | Sin cambios ✅ |

---

## 📊 Reportes

Después de `mvn test`, los reportes se generan en:
- `target/karate-reports/karate-summary.html` → Reporte visual interactivo
- `target/karate-reports/*.html` → Reporte detallado por feature
- `target/karate.log` → Log completo de ejecución
- `target/surefire-reports/` → Reportes JUnit XML (para CI/CD)

---

## 🧩 Conceptos demostrados

- ✅ GET, POST, PUT, PATCH, DELETE
- ✅ Schema validation con fuzzy matchers (`#string`, `#number`, `#object`, `#regex`)
- ✅ Data-driven tests con `Scenario Outline` + `Examples`
- ✅ Callable features (helpers reutilizables)
- ✅ Datos externos en JSON
- ✅ Query params, path params, headers
- ✅ Configuración por entorno (`karate-config.js`)
- ✅ Bearer Token y auth flows
- ✅ Ejecución paralela con Virtual Threads (Java 21)
- ✅ Tags para clasificar y filtrar tests
