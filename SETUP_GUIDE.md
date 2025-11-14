# 🚀 SwiftUI iOS App - Kompletny Przewodnik Setup

Natywna aplikacja iOS napisana w SwiftUI dla systemu ewidencji sprzętu kitesurfingu.

---

## 📋 Wymagania

- **macOS:** 13.0+ (Ventura lub nowszy)
- **Xcode:** 15.0+
- **iOS:** 16.0+ (target deployment)
- **Swift:** 5.9+

---

## 🎯 Krok 1: Utwórz Projekt w Xcode

1. **Otwórz Xcode**

2. **Utwórz nowy projekt:**
   - File → New → Project (lub ⇧⌘N)
   - Wybierz **"iOS"** → **"App"**
   - Kliknij **Next**

3. **Skonfiguruj projekt:**
   - **Product Name:** `KiteEquipmentApp`
   - **Team:** Wybierz swój Apple Developer Team (lub "None" dla developmentu)
   - **Organization Identifier:** `com.yourcompany` (zmień na swoją)
   - **Bundle Identifier:** `com.yourcompany.KiteEquipmentApp`
   - **Interface:** **SwiftUI** ✅
   - **Language:** **Swift** ✅
   - **Storage:** None
   - **Use Core Data:** ❌ (unchecked)
   - **Include Tests:** ✅ (opcjonalnie)

4. **Wybierz lokalizację** i kliknij **Create**

---

## 📁 Krok 2: Skopiuj Pliki

### Struktura folderów w Xcode:

Utwórz następującą strukturę (File → New → Group):

```
KiteEquipmentApp/
├── Models/
├── ViewModels/
├── Views/
│   └── Components/
├── Services/
└── Utils/
```

### Skopiuj pliki:

Z folderu `/ios-swiftui/KiteEquipmentApp/` skopiuj wszystkie pliki `.swift` do odpowiednich folderów w Xcode:

**1. Models:**
- `Equipment.swift`
- `HistoryEntry.swift`
- `User.swift`

**2. ViewModels:**
- `AuthViewModel.swift`
- `EquipmentViewModel.swift`

**3. Views:**
- `SplashView.swift`
- `GuestView.swift`
- `AdminView.swift`
- `LoginView.swift`
- `UseEquipmentSheet.swift`
- `QRScannerView.swift`
- `HistoryView.swift`

**4. Views/Components:**
- `EquipmentCard.swift`
- `StatusBadge.swift`

**5. Services:**
- `NetworkService.swift`

**6. Utils:**
- `Constants.swift`

**7. Root (obok ContentView.swift):**
- `KiteEquipmentApp.swift` (zamień istniejący plik)

### Sposób kopiowania w Xcode:

1. Przeciągnij pliki `.swift` z Findera do odpowiednich folderów w Xcode
2. W dialogu wybierz:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ Target: KiteEquipmentApp
3. Kliknij **Finish**

---

## ⚙️ Krok 3: Konfiguracja Info.plist

### Dodaj uprawnienia kamery:

1. W Xcode, znajdź plik **Info.plist** w navigatorze projektu

2. **Metoda 1 - GUI:**
   - Kliknij prawym na Info.plist → **Open As** → **Property List**
   - Kliknij `+` aby dodać nowy wpis
   - Key: `Privacy - Camera Usage Description`
   - Type: String
   - Value: `Aplikacja potrzebuje dostępu do kamery dla skanowania kodów QR sprzętu.`

3. **Metoda 2 - Source Code (zalecane):**
   - Kliknij prawym na Info.plist → **Open As** → **Source Code**
   - Dodaj przed `</dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikacja potrzebuje dostępu do kamery dla skanowania kodów QR sprzętu.</string>
```

---

## 🌐 Krok 4: Skonfiguruj Backend URL

1. Otwórz plik **`Utils/Constants.swift`**

2. **Upewnij się że masz poprawne dane:**

```swift
struct Constants {
    static let SUPABASE_URL = "https://tjfstsjvuewxnixwwnsk.supabase.co"
    static let SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    // ... reszta
}
```

✅ Dane są już poprawne - nie musisz ich zmieniać!

---

## 🔧 Krok 5: Build Settings

### Ustaw Deployment Target:

1. Wybierz projekt w navigatorze (niebieski icon)
2. Wybierz target **KiteEquipmentApp**
3. Zakładka **General**
4. **Minimum Deployments:** iOS 16.0

### Capabilities (opcjonalnie):

Jeśli potrzebujesz dodatkowych funkcji:

1. Zakładka **Signing & Capabilities**
2. Kliknij **+ Capability**
3. Dodaj:
   - Push Notifications (dla powiadomień)
   - Background Modes (dla background sync)

---

## ▶️ Krok 6: Uruchom Aplikację

### Na Symulatorze:

1. Wybierz symulator z górnego menu (np. **iPhone 15 Pro**)
2. Naciśnij **⌘+R** (lub kliknij ▶️ Play)
3. Poczekaj na build...
4. Aplikacja uruchomi się! 🎉

### Na Prawdziwym iPhone:

1. **Podłącz iPhone** przez USB
2. **Odblokuj iPhone**
3. Jeśli pojawi się alert "Trust This Computer" → **Trust**
4. W Xcode, wybierz swój iPhone z górnego menu
5. **Signing & Capabilities:**
   - Wybierz swój Team
   - Xcode automatycznie utworzy provisioning profile
6. Naciśnij **⌘+R**
7. Na iPhone:
   - Settings → General → VPN & Device Management
   - Kliknij swój Apple ID → **Trust**
8. Uruchom aplikację ponownie
9. **Gotowe!** 🎉

---

## 🧪 Krok 7: Testowanie

### Podstawowe funkcje:

1. ✅ **Splash Screen** - Powinien pokazać się przez 2 sekundy
2. ✅ **Guest View** - Lista sprzętu się ładuje
3. ✅ **Wyszukiwanie** - Wpisz "North" w search
4. ✅ **Filtrowanie** - Kliknij "Latawiec"
5. ✅ **Użyj sprzęt** - Kliknij "Użyj" na dostępnym sprzęcie
6. ✅ **QR Scanner** - Kliknij niebieski przycisk (tylko na prawdziwym iPhone!)
7. ✅ **Login** - Kliknij ikonę osoby → Zaloguj się
8. ✅ **Admin Panel** - Dodaj/edytuj/usuń sprzęt
9. ✅ **Historia** - Zobacz historię użycia

### Dane testowe:

**Admin login:**
- Email: `admin@kiteschool.com`
- Hasło: `Admin123!`

*(Najpierw uruchom `setup-sample-data.html` w przeglądarce!)*

---

## 🎨 Krok 8: Customizacja (Opcjonalnie)

### Zmień nazwę aplikacji:

1. Wybierz projekt → target KiteEquipmentApp
2. **General** → **Display Name:** Twoja nazwa

### Zmień Bundle ID:

1. Wybierz projekt → target KiteEquipmentApp
2. **General** → **Bundle Identifier:** com.twojafirma.nazwaapp

### Dodaj ikonę aplikacji:

1. Przygotuj ikonę 1024x1024 px (PNG, bez alpha)
2. W Xcode: **Assets.xcassets** → **AppIcon**
3. Przeciągnij obrazy do odpowiednich slotów

**Narzędzia do generowania ikon:**
- https://www.appicon.co/
- https://easyappicon.com/

### Zmień kolory:

W `SplashView.swift` zmień gradient:
```swift
LinearGradient(
    colors: [Color(hex: "0ea5e9"), Color(hex: "0284c7")],
    // Zmień na swoje kolory
)
```

---

## 🐛 Troubleshooting

### Build errors?

**"Cannot find type..."**
- Sprawdź czy wszystkie pliki .swift zostały dodane do projektu
- File → Add Files to "KiteEquipmentApp"

**"Module compiled with Swift X.X cannot be imported..."**
- Clean Build Folder: Product → Clean Build Folder (⇧⌘K)
- Restart Xcode

### Kamera nie działa?

**Na symulatorze:**
- Symulator nie ma kamery - użyj prawdziwego iPhone!

**Na prawdziwym urządzeniu:**
- Sprawdź czy dodałeś `NSCameraUsageDescription` do Info.plist
- Settings → App → Camera (sprawdź uprawnienia)

### Nie łączy się z API?

1. Sprawdź `Constants.swift` - czy URL i key są poprawne?
2. Sprawdź czy backend działa - otwórz `test-backend.html`
3. Sprawdź console w Xcode (View → Debug Area → Activate Console)

### Czarny ekran po uruchomieniu?

- Sprawdź czy `KiteEquipmentApp.swift` został poprawnie skopiowany
- Sprawdź console dla błędów
- Restart aplikacji (⌘+R)

---

## 📱 Build dla App Store

### Przygotowanie:

1. **Apple Developer Account** - $99/rok
   - https://developer.apple.com/programs/

2. **App Store Connect:**
   - Utwórz nową aplikację
   - Wypełnij metadata (nazwa, opis, screenshoty)

3. **Certificates & Provisioning:**
   - Xcode → Preferences → Accounts
   - Download Manual Profiles
   - Signing & Capabilities → Automatically manage signing ✅

### Archive i Upload:

1. **Wybierz "Any iOS Device"** z górnego menu
2. **Product → Archive**
3. Poczekaj na zakończenie...
4. W Organizer:
   - Wybierz swój archive
   - **Distribute App**
   - **App Store Connect**
   - **Upload**
5. W App Store Connect:
   - Submit for Review
   - Poczekaj na approval (1-7 dni)

---

## 📊 Porównanie: SwiftUI vs Capacitor

| Feature | SwiftUI (Native) | Capacitor |
|---------|-----------------|-----------|
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Native UI** | ✅ 100% | ❌ WebView |
| **Code Size** | Mały | Większy |
| **Maintenance** | Osobny kod | Współdzielony |
| **Updates** | Wymaga rebuild | Możliwe OTA* |
| **Learning curve** | Swift/SwiftUI | React |
| **QR Scanner** | AVFoundation ✅ | Plugin |
| **Offline** | ✅ Native | ✅ Service Worker |

*OTA = Over-The-Air updates

---

## 🎓 Następne Kroki

### Dodatkowe Funkcje:

1. **Core Data** - Offline storage
2. **Push Notifications** - Powiadomienia
3. **WidgetKit** - Widgets na ekranie głównym
4. **Face ID / Touch ID** - Biometryczne logowanie
5. **Haptics** - Wibracje przy skanowaniu QR
6. **Background Refresh** - Auto-sync w tle

### Uczenie się SwiftUI:

- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com/100/swiftui)
- [Swift by Sundell](https://www.swiftbysundell.com/)

---

## ✅ Checklist

- [ ] Projekt utworzony w Xcode
- [ ] Wszystkie pliki .swift skopiowane
- [ ] Info.plist skonfigurowany (Camera permission)
- [ ] Constants.swift sprawdzony
- [ ] Build successful na symulatorze
- [ ] Testowane na prawdziwym iPhone
- [ ] QR Scanner działa
- [ ] Login admin działa
- [ ] Wszystkie funkcje przetestowane
- [ ] Ikona aplikacji dodana (opcjonalnie)

---

## 🎉 Gratulacje!

Masz teraz pełnoprawną natywną aplikację iOS napisaną w SwiftUI!

**Różnice od React:**
- ✅ **Pełna natywna wydajność** - brak WebView
- ✅ **Native iOS UI** - zgodność z Human Interface Guidelines
- ✅ **Lepszy QR Scanner** - używa AVFoundation
- ✅ **Mniejszy rozmiar** - brak JavaScript runtime

**Twój kod:**
- 100% Swift
- SwiftUI dla UI
- Combine dla reactive programming
- Async/await dla networking

Powodzenia z aplikacją! 🏄‍♂️

---

**Pytania?** Sprawdź:
- [Swift Documentation](https://swift.org/documentation/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Apple Developer Forums](https://developer.apple.com/forums/)
