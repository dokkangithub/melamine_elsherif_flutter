# ObjectBox Setup Instructions

This project uses ObjectBox for local database storage. To complete the setup, follow these steps:

## Step 1: Generate ObjectBox model code

Run the following command to generate the required ObjectBox files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the following files:
- `lib/objectbox.g.dart` - Generated bindings
- `.objectbox` directory with ObjectBox model info

## Step 2: Setup Entity Models

Make sure your entity models are configured properly with ObjectBox annotations:

```dart
import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id()
  int id = 0;
  
  String name;
  double price;
  
  Product({
    required this.name,
    required this.price,
  });
}
```

## Step 3: Initialize ObjectBox in your app

The initialization is already handled in `lib/objectbox.dart`, but you need to make sure the Store is created at application startup:

```dart
import 'package:your_app_name/objectbox.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await openStore();
  
  runApp(MyApp(store: store));
}
```

## Troubleshooting

If you encounter any issues with ObjectBox setup:

1. Make sure you have the correct dependencies in `pubspec.yaml`:
   - `objectbox: ^2.5.1`
   - `objectbox_flutter_libs: ^2.5.1`
   - `build_runner: ^2.4.8` (dev dependency)
   - `objectbox_generator: ^2.5.1` (dev dependency)

2. Try cleaning the build before generating:
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Check if all entity models have proper annotations and fields. 