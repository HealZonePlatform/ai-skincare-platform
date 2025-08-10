// lib/utils/api_constants.dart

class ApiConstants {
  // QUAN TRỌNG: Thay thế 'YOUR_LOCAL_IP' bằng địa chỉ IP của máy tính trong mạng LAN.
  // Ví dụ: '192.168.1.10'.
  // Không được dùng 'localhost' hoặc '127.0.0.1' vì máy ảo Android/iOS
  // sẽ không thể kết nối đến máy tính của bạn qua địa chỉ đó.
  // Bạn có thể tìm IP của mình bằng lệnh `ipconfig` (Windows) hoặc `ifconfig` (macOS/Linux).
  static const String _localIp = 'YOUR_LOCAL_IP'; 
  static const String baseUrl = 'http://192.168.56.1:3001/api/v1';
  
  static const String registerUrl = '$baseUrl/auth/register';
  static const String loginUrl = '$baseUrl/auth/login';
}