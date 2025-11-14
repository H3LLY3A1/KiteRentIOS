# 🚀 SwiftUI App - Quick Start (15 minut)

Najszybszy sposób aby uruchomić natywną aplikację iOS.

---

## ✅ Wymagania
- macOS 13+
- Xcode 15+
- 15 minut

---

## 📝 Krok 1: Xcode Project (2 min)

```
1. Otwórz Xcode
2. File → New → Project (⇧⌘N)
3. iOS → App
4. Product Name: KiteEquipmentApp
5. Interface: SwiftUI ✅
6. Language: Swift ✅
7. Create
```

---

## 📁 Krok 2: Skopiuj Pliki (5 min)

### Utwórz foldery w Xcode:
```
File → New → Group
Nazwy: Models, ViewModels, Views, Services, Utils
```

### Przeciągnij pliki:

**Z `/ios-swiftui/KiteEquipmentApp/` przeciągnij do Xcode:**

```
Models/
├── Equipment.swift
├── HistoryEntry.swift
└── User.swift

ViewModels/
├── AuthViewModel.swift
└── EquipmentViewModel.swift

Views/
├── SplashView.swift
├── GuestView.swift
├── AdminView.swift
├── LoginView.swift
├── QRScannerView.swift
├── HistoryView.swift
├── UseEquipmentSheet.swift
└── Components/
    ├── EquipmentCard.swift
    └── StatusBadge.swift

Services/
└── NetworkService.swift

Utils/
└── Constants.swift

Root/
└── KiteEquipmentApp.swift (zamień istniejący)
```

**Przy przeciąganiu:**
- ✅ Copy items if needed
- ✅ Create groups
- ✅ Target: KiteEquipmentApp

---

## ⚙️ Krok 3: Info.plist (2 min)

**Dodaj uprawnienie kamery:**

1. Znajdź `Info.plist`
2. Kliknij prawym → Open As → Source Code
3. Dodaj przed `</dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikacja potrzebuje dostępu do kamery dla skanowania kodów QR sprzętu.</string>
```

---

## ▶️ Krok 4: Build & Run (1 min)

```
1. Wybierz symulator (iPhone 15 Pro)
2. Naciśnij ⌘+R
3. Poczekaj...
4. GOTOWE! 🎉
```

---

## 🧪 Krok 5: Test (5 min)

### Podstawowe testy:

✅ **Splash screen** - Animacja 2 sek
✅ **Lista sprzętu** - Ładuje się
✅ **Wyszukiwanie** - Wpisz "North"
✅ **Login** - Ikona osoby → admin@kiteschool.com / Admin123!

### Na prawdziwym iPhone:

```
1. Podłącz iPhone
2. Wybierz iPhone w Xcode
3. ⌘+R
4. Trust certificate na iPhone
5. ⌘+R ponownie
```

✅ **QR Scanner** - Niebieski przycisk → Skieruj na QR

---

## 🐛 Problemy?

### Build fails?
```bash
⇧⌘K (Clean Build Folder)
⌘+R (Build Again)
```

### "Cannot find type..."?
```
Sprawdź czy wszystkie pliki .swift są w projekcie
File → Add Files to "KiteEquipmentApp"
```

### Kamera nie działa?
```
• Symulator nie ma kamery - użyj iPhone
• Sprawdź Info.plist - Camera permission
```

---

## 📚 Następne Kroki

**→ Pełna dokumentacja:** [SETUP_GUIDE.md](SETUP_GUIDE.md)

**→ Dodaj funkcje:**
- Ikona aplikacji (Assets.xcassets → AppIcon)
- Zmień kolory (SplashView.swift)
- Customizacja (Constants.swift)

**→ Publish:**
- Apple Developer Account ($99/rok)
- Product → Archive
- Distribute → App Store

---

## ✨ Funkcje

- ✅ Natywny QR Scanner (AVFoundation)
- ✅ 100% SwiftUI UI
- ✅ Dark Mode support
- ✅ iPad compatible
- ✅ Async/Await networking
- ✅ MVVM architecture

---

## 🎯 Dane Testowe

**Backend:** Najpierw uruchom `setup-sample-data.html`

**Admin login:**
- Email: `admin@kiteschool.com`
- Hasło: `Admin123!`

---

## 💡 Porady

1. **Zawsze wybieraj .xcodeproj** w navigatorze
2. **⌘+B** - Build without run (szybsze testowanie)
3. **Console** - View → Debug Area (⇧⌘Y)
4. **Shortcuts:**
   - ⌘+R - Run
   - ⌘+. - Stop
   - ⇧⌘K - Clean
   - ⌘+B - Build

---

## 🎉 Sukces!

Gratulacje! Masz natywną aplikację iOS w SwiftUI!

**Twoja aplikacja:**
- ⚡ Natywna wydajność
- 📱 iOS native UI
- 🎨 SwiftUI design
- 🔒 Type-safe Swift

**Time:** ~15 minut total  
**Result:** Production-ready iOS app! 🏄‍♂️

---

**Masz pytania?** Zobacz [SETUP_GUIDE.md](SETUP_GUIDE.md)
