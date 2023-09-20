# Geofencing Flutter App

Welcome to the Geofencing Flutter App! This Flutter application allows users to signin and submit reports when they are in a specified geographical area. Geofencing can be a powerful tool for location-based applications, and this repository provides you with a starting point to implement geofencing features in your Flutter projects. Signing and submitting report is handled by firebase

## Features

- Set up geofences to monitor specific locations.
- Easy-to-use interface for managing geofences.

## Getting Started

Follow these steps to get started with the Geofencing Flutter App:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Inihood1/Flutter-geonfencing.git
   ```

2. Open the project in your favorite Flutter IDE (e.g., Android Studio, Visual Studio Code).

3. Run the app on an emulator or physical device:

   ```bash
   flutter run
   ```

4. Configure the geofences in the app according to your requirements.

5. Test the geofencing functionality by defining your geofence areas.

## Dependencies

This project relies on these core packages:

- [geolocator](https://pub.dev/packages/geolocator) for location service.
- [latlong2](https://pub.dev/packages/latlong2) for geofencing functionality and calculating distance between 2 locations.
- [provider](https://pub.dev/packages/provider) for state management.

You can find the complete list of dependencies in the `pubspec.yaml` file.

## Customization

### Geofence Image

To customize the geofence image/icon, replace the `assets/geofence.png` file with your preferred image. Make sure to maintain the same filename and format (PNG) to avoid any code changes.

### Notifications

Customize the geofencing notifications by modifying the notification settings in the code. You can change the notification sound, appearance, and content to match your app's branding and user experience.

## Contribution

Contributions are welcome! If you have any feature suggestions, bug reports, or improvements, please feel free to open an issue or submit a pull request. Let's make this geofencing Flutter app even better together.

## License

This Geofencing Flutter App is open-source and available under the [MIT License](LICENSE). You are free to use, modify, and distribute it as per the terms of the license.

---

**Note**: This readme is a template and should be customized to provide specific details about your geofencing Flutter app. Make sure to update the placeholders such as `yourusername` and provide detailed instructions for asset replacement and app configuration.
