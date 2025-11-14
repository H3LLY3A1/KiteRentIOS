# 🍎 Natywna Aplikacja iOS - SwiftUI

Kompletna natywna aplikacja iOS napisana w SwiftUI dla systemu ewidencji sprzętu kitesurfingu.

## 📋 Struktura Projektu

```
KiteEquipmentApp/
├── KiteEquipmentApp.swift          # App entry point
├── Models/
│   ├── Equipment.swift             # Model sprzętu
│   ├── HistoryEntry.swift          # Model historii
│   └── User.swift                  # Model użytkownika
├── ViewModels/
│   ├── EquipmentViewModel.swift    # Logic dla sprzętu
│   ├── AuthViewModel.swift         # Logic dla auth
│   └── HistoryViewModel.swift      # Logic dla historii
├── Views/
│   ├── SplashView.swift            # Splash screen
│   ├── GuestView.swift             # Widok instruktora
│   ├── AdminView.swift             # Widok admina
│   ├── LoginView.swift             # Ekran logowania
│   ├── EquipmentListView.swift     # Lista sprzętu
│   ├── EquipmentDetailView.swift   # Szczegóły sprzętu
│   ├── QRScannerView.swift         # Skaner QR
│   ├── HistoryView.swift           # Historia użycia
│   └── Components/
│       ├── EquipmentCard.swift     # Karta sprzętu
│       ├── StatusBadge.swift       # Badge statusu
│       └── FilterBar.swift         # Pasek filtrów
├── Services/
│   ├── NetworkService.swift        # API client
│   ├── AuthService.swift           # Autentykacja
│   └── StorageService.swift        # Local storage
└── Utils/
    ├── Constants.swift             # Stałe
    └── Extensions.swift            # Extensions
```

## 🚀 Instalacja

### Wymagania:
- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+

### Kroki:

1. **Otwórz Xcode**
2. **File → New → Project**
3. Wybierz **"App"** (iOS)
4. **Product Name:** KiteEquipmentApp
5. **Interface:** SwiftUI
6. **Language:** Swift
7. Kliknij **Create**

8. **Skopiuj pliki** z folderu `/ios-swiftui/KiteEquipmentApp/` do swojego projektu

9. **Dodaj uprawnienia** do Info.plist:
   - Camera: dla QR skanera
   - Network: dla API

10. **Uruchom:** ⌘+R

## 📦 Funkcje

- ✅ Natywny UI w SwiftUI
- ✅ QR Scanner z AVFoundation
- ✅ Offline support z CoreData/UserDefaults
- ✅ Real-time sync z Supabase
- ✅ Autentykacja admin
- ✅ Lista i zarządzanie sprzętem
- ✅ Historia użycia
- ✅ Dark mode support
- ✅ iPad support

## 🔧 Konfiguracja

Edytuj `Utils/Constants.swift` i zaktualizuj:
```swift
let SUPABASE_URL = "https://tjfstsjvuewxnixwwnsk.supabase.co"
let SUPABASE_ANON_KEY = "twój-klucz"
```

## 📱 Screeny

1. **Splash Screen** - Animowane logo
2. **Guest View** - Lista sprzętu dla instruktorów
3. **Admin View** - Panel zarządzania
4. **QR Scanner** - Natywne skanowanie
5. **History** - Historia użycia

## 🎯 Następne Kroki

Po utworzeniu projektu w Xcode, skopiuj wszystkie pliki .swift i uruchom aplikację!
