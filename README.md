# Mystic Pages

# Blind Date with a Book – iOS App

## ✨ Die Idee
Es begann mit einer einfachen Vision: Was wäre, wenn man ein Buch völlig ohne Vorurteile entdecken könnte? Kein Cover, kein Hype, kein Klappentext – nur ein Genre und ein Bauchgefühl. So entstand die Idee für **„Blind Date with a Book“** – eine iOS-App, bei der du dich auf ein Zufallsbuch einlässt, das vielleicht genau dein nächstes Lieblingsbuch wird.

---

## ✍️ Von Skizzen zu SwiftUI
Jeder Screen begann mit einem Bleistiftstrich. Die Idee wurde konkret, als erste Layouts entstanden:

- 📥 **LoginView**: Mit Logo, Feldern und sanftem Einstieg
- 👤 **ProfilView**: Mit Upload für Profilbild und späteren Community-Funktionen
- 📖 **BookDetailView**: Cover, Titel, Autor, Kaufoption und Lieblingsbuch-Save
- 📝 **QuotesView**: Um deine Lieblingszitate wie in einem Social Feed festzuhalten
- 📚 **LibraryView**: Bücher im virtuellen Regal – wie bei dir zuhause
- 🎲 **HomeView**: Dein Blind Date – animiert, überraschend, inspirierend

> Alle Skizzen wurden als visuelle Grundlage genutzt und flossen direkt in das UI/UX-Konzept der App ein:

<p>
 
 <img src="https://github.com/SI-Classroom-Batch-023/03-ios-abschluss-Ceylan97/blob/2155cc42977acbf67528fa7a9c085a93ebc0acca/skizzen.png?raw=true" width="900">

</p>

---

## 🖼️ Der aktuelle Stand – Screenshots
Hier ein Blick auf den bisherigen Entwicklungsstand in der App:

<p>
     <img src="https://github.com/SI-Classroom-Batch-023/03-ios-abschluss-Ceylan97/blob/2155cc42977acbf67528fa7a9c085a93ebc0acca/hifidesign.png?raw=true" width="1500">
  
</p>

---

## 🎨 Das Designsystem
Damit alles zusammenpasst, wurde ein modulares Designsystem entwickelt – mit klaren Farben, Typografie und wiederverwendbaren Komponenten.

```swift
struct DesignSystem {
    struct Colors {
        static let background = Color("colorbackground")
        static let buttons = Color("colorbuttons")
        static let elements = Color("colorelements")
        static let icons = Color("coloricons")
        static let quotes = Color("colorquotes")
        static let section = Color("colorsection")
    }
    struct Fonts {
        static let sectionHeader = Font.system(.title3, design: .rounded).weight(.semibold)
        static let body = Font.system(.body, design: .rounded)
        static let subheadline = Font.system(.subheadline, design: .rounded)
        static let headline = Font.system(.headline, design: .rounded)
    }
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 6
    static let cardShadow = Color.black.opacity(0.16)
}
```

> Genutzt wird es durch `.dsCardStyle()`, `.dsBookImage()`, `.dsEmptyStateText()` uvm.

---

## 🔧 Technischer Aufbau

### 🔹 Projektstruktur
- **MVVM**-Architektur mit Services und Extensions
- Modularer Aufbau: `Views`, `ViewModels`, `Models`, `Services`, `Design`

### 🔹 Daten & API
- **Firebase** für Authentifizierung, Firestore für Bücher, Zitate, Userdaten
- **Google Books API** für dynamisches Book-Discovery
- **Images & Cover** werden aus der API geladen oder manuell ergänzt

### 🔹 Verwendete Frameworks
- Firebase Auth & Firestore (SPM)
- GoogleBooksKit (eigene Schnittstelle)
- (geplant) Spline für interaktive UI-Elemente


---

## 🧩 Aktuelle Features

- [x] Firebase-Login mit E-Mail (Google geplant)
- [x] ToRead-Grid mit modernen Cards
- [x] Zufällige Bücher durch Google Books API
- [x] Speichern, Liken & visuelle BookCards
- [x] Eigene Zitate anlegen und ansehen
- [x] Bibliothek im Regalstil
- [x] Einheitliches Farb- & Fontsystem
- [x] SettingsView mit Profilfunktionen

---

## 🛠️ Features in Entwicklung

- [ ] BookRatingView mit Foto & Notizen
- [ ] Spice-Rating (Dark Romance)
- [ ] Darkmode-Switch
- [ ] Chatfunktion mit Firestore
- [ ] Zitate posten & kommentieren wie in Social Media
- [ ] Integration von Spline (animierte 3D-Effekte)

---

## 🛣️ Der Weg geht weiter …
Diese App ist nicht nur ein Abschlussprojekt, sondern der Anfang von etwas Größerem. Mit jeder Zeile Code wächst sie – in Design, in Funktion, in Persönlichkeit.

> **To be continued...**

❤️ Entwickelt mit SwiftUI, einer Portion Kaffee & viel Liebe zu Büchern.


