<div align="center">

# 📝 Smart Note

**Ứng dụng ghi chú thông minh, đơn giản và tối giản**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

</div>

---

## 📖 Giới thiệu

**Smart Note** là một ứng dụng ghi chú đa nền tảng được xây dựng bằng **Flutter**, hướng đến trải nghiệm người dùng tối giản và hiệu quả. Ứng dụng cho phép tạo, chỉnh sửa, tìm kiếm và xóa ghi chú hoàn toàn offline với giao diện Material 3 hiện đại.

---

## ✨ Tính năng

| Tính năng | Mô tả |
|---|---|
| 📄 **Tạo ghi chú** | Tạo ghi chú mới với tiêu đề và nội dung |
| ✏️ **Chỉnh sửa** | Chỉnh sửa ghi chú bất kỳ lúc nào |
| 🗑️ **Xóa ghi chú** | Xóa ghi chú với hộp thoại xác nhận |
| 🔍 **Tìm kiếm real-time** | Lọc ghi chú theo tiêu đề hoặc nội dung ngay khi gõ |
| 💾 **Tự động lưu** | Auto-save khi người dùng thoát màn hình soạn thảo |
| 📱 **Staggered Grid** | Hiển thị danh sách ghi chú dạng lưới so le |
| 🎨 **Giao diện Material 3** | Theme chủ đạo màu xanh sage, ấm áp và tối giản |
| 📦 **Lưu trữ cục bộ** | Dữ liệu lưu trên thiết bị, hoạt động hoàn toàn offline |

---

## 🛠️ Công nghệ sử dụng

### Framework & Ngôn ngữ
- **[Flutter](https://flutter.dev/)** `^3.x` — Cross-platform UI framework
- **[Dart](https://dart.dev/)** `^3.10.7` — Ngôn ngữ lập trình

### Thư viện chính

| Package | Phiên bản | Mục đích |
|---|---|---|
| `shared_preferences` | `^2.2.2` | Lưu trữ dữ liệu cục bộ |
| `flutter_staggered_grid_view` | `^0.7.0` | Hiển thị lưới so le |
| `intl` | `^0.19.0` | Định dạng ngày giờ |
| `uuid` | `^4.2.1` | Tạo ID duy nhất cho ghi chú |
| `cupertino_icons` | `^1.0.8` | Bộ icon iOS |

---

## 📁 Cấu trúc dự án

```
smart_note/
├── lib/
│   ├── main.dart                  # Entry point, cấu hình theme ứng dụng
│   ├── models/
│   │   └── note.dart              # Model Note (id, title, content, timestamps)
│   ├── screens/
│   │   ├── home_screen.dart       # Màn hình chính – danh sách & tìm kiếm
│   │   └── note_edit_screen.dart  # Màn hình soạn thảo ghi chú
│   └── services/
│       └── note_storage.dart      # Service đọc/ghi dữ liệu (SharedPreferences)
├── android/                       # Cấu hình Android
├── ios/                           # Cấu hình iOS
├── web/                           # Cấu hình Web
├── windows/                       # Cấu hình Windows
├── linux/                         # Cấu hình Linux
├── macos/                         # Cấu hình macOS
├── pubspec.yaml                   # Khai báo dependencies
└── README.md
```

---

## 🚀 Hướng dẫn cài đặt & chạy

### Yêu cầu
- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.10.0`
- Dart SDK `>=3.10.7`
- Android Studio / VS Code với Flutter extension

### Các bước thực hiện

**1. Clone dự án**
```bash
git clone https://github.com/<your-username>/smart_note.git
cd smart_note
```

**2. Cài đặt dependencies**
```bash
flutter pub get
```

**3. Chạy ứng dụng**
```bash
# Android / iOS
flutter run

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

**4. Build release (Android)**
```bash
flutter build apk --release
```

---

## 🏗️ Kiến trúc ứng dụng

```
┌─────────────────────────────────────┐
│            UI Layer                 │
│   HomeScreen   NoteEditScreen       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Service Layer             │
│         NoteStorage                 │
│   (CRUD via SharedPreferences)      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Data Layer                │
│     Note Model (JSON serialize)     │
└─────────────────────────────────────┘
```

### Luồng hoạt động

- **Load**: `NoteStorage.loadNotes()` → giải mã JSON từ SharedPreferences → hiển thị danh sách
- **Create / Edit**: Người dùng soạn thảo → nhấn Back → `_autoSave()` → `NoteStorage.saveNote()`
- **Delete**: Swipe-to-dismiss → dialog xác nhận → `NoteStorage.deleteNote()`
- **Search**: Gõ từ khóa → `_filterNotes()` lọc real-time theo title/content

---

## 📱 Nền tảng hỗ trợ

| Nền tảng | Trạng thái |
|---|---|
| ✅ Android | Hỗ trợ |
| ✅ iOS | Hỗ trợ |
| ✅ Web | Hỗ trợ |
| ✅ Windows | Hỗ trợ |
| ✅ macOS | Hỗ trợ |
| ✅ Linux | Hỗ trợ |


## 📄 Giấy phép

Dự án được phân phối theo giấy phép [MIT](LICENSE).

---

<div align="center">
  <sub>Built with ❤️ using Flutter</sub>
</div>

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
