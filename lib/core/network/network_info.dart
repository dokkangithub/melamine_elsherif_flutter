import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface to check network connectivity
abstract class NetworkInfo {
  /// Check if the device is connected to the internet
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  /// Creates a [NetworkInfoImpl] instance
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    return result != ConnectivityResult.none;
  }
} 