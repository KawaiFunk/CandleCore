# Titlul proiectului

**Sistem informatic de monitorizare și analiză a prețurilor activelor digitale în timp real**

---

## Scopul proiectului

Lucrarea de față are ca obiectiv dezvoltarea unui sistem informatic destinat monitorizării și analizei prețurilor activelor digitale în timp real.

Sistemul permite:
- colectarea automată a datelor din surse externe,
- stocarea și gestionarea informațiilor într-o bază de date,
- vizualizarea evoluțiilor de preț,
- configurarea alertelor,
- gestionarea portofoliului de active.

Prin automatizarea proceselor de actualizare, sistemul reduce verificarea manuală și asigură acces rapid la informații relevante.

---

## Tehnologiile / instrumentele utilizate

### Backend:
- .NET
- C#
- ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- MediatR
- Clean Architecture

### Frontend (Mobile):
- Flutter
- Dart
- Riverpod
- GoRouter

### Instrumente de dezvoltare:
- Rider
- Android Studio
- DataGrip
- Git

---

## Instrucțiuni de rulare a aplicației / sistemului

### 1. Clonare repository

```bash
git clone <url-repository>
cd CandleCore
```

### 2. Rulare Backend

1. Deschide soluția `CandleCore.sln`
2. Configurează connection string-ul pentru PostgreSQL în `appsettings.json`
3. Rulează migrațiile bazei de date (dacă este necesar)
4. Build și Run proiectul `CandleCore.Api`

### 3. Rulare aplicație Flutter

```bash
cd CandleCore.Web/candle_core
flutter pub get
flutter run
```

---

## Structura aplicației

CandleCore/
├── CandleCore.Domain/
├── CandleCore.Application/
├── CandleCore.Infrastructure/
├── CandleCore.Api/
└── CandleCore.Web/

Arhitectură: Clean Architecture (Domain → Application → Infrastructure → Api)