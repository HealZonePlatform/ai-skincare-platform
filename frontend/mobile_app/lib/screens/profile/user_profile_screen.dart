// lib/screens/profile/user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ai_skincare_platform/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/models/user_profile.dart';
import 'package:ai_skincare_platform/providers/auth_provider.dart';
import 'package:ai_skincare_platform/screens/profile/skin_analysis_detail_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
 final _phoneNumberController = TextEditingController();
  bool _isEditing = false;
  bool _showPasswordChangeForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, profileProvider, child) {
        final userProfile = profileProvider.userProfile;
        final history = profileProvider.skinAnalysisHistory;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ người dùng'),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                  if (_isEditing) {
                    // Lưu thông tin khi kết thúc chỉnh sửa
                    if (_formKey.currentState!.validate()) {
                      profileProvider.updateUserProfile(
                        fullName: _fullNameController.text,
                        phoneNumber: _phoneNumberController.text,
                      ).then((success) {
                        if (success) {
                          setState(() {
                            _isEditing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật hồ sơ thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(profileProvider.errorMessage ?? 'Lỗi khi cập nhật hồ sơ'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    }
                  } else {
                    // Bắt đầu chỉnh sửa
                    _fullNameController.text = userProfile?.fullName ?? '';
                    _phoneNumberController.text = userProfile?.phoneNumber ?? '';
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
              ),
            ],
          ),
          body: profileProvider.isLoading && userProfile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar và thông tin cơ bản
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3, // Responsive width
                              height: MediaQuery.of(context).size.width * 0.3, // Responsive height
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: userProfile?.avatarUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: userProfile!.avatarUrl!,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.person,
                                          size: 40, // Responsive size
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 40, // Responsive size
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Form thông tin người dùng
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              enabled: _isEditing,
                              decoration: const InputDecoration(
                                labelText: 'Họ và tên',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (_isEditing && (value == null || value.isEmpty)) {
                                  return 'Vui lòng nhập họ và tên';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _phoneNumberController,
                              enabled: _isEditing,
                              decoration: const InputDecoration(
                                labelText: 'Số điện thoại',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (_isEditing && value != null && value.isNotEmpty) {
                                  // Kiểm tra định dạng số điện thoại Việt Nam
                                  final phoneRegex = RegExp(r'^(0|\+84)(3|5|7|8|9)\d{8}$');
                                  if (!phoneRegex.hasMatch(value)) {
                                    return 'Vui lòng nhập số điện thoại hợp lệ';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              initialValue: userProfile?.email,
                              enabled: false, // Email không cho phép chỉnh sửa
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Tiêu đề lịch sử phân tích da
                      const Text(
                        'Lịch sử phân tích da',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Danh sách lịch sử phân tích
                      profileProvider.isLoading && history.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : history.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Chưa có lịch sử phân tích da',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: history.length,
                                  itemBuilder: (context, index) {
                                    final item = history[index];
                                    return Card(
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: item.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          'Phân tích #${item.id.substring(0, 8)}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          'Ngày: ${item.createdAt.toString().split(' ')[0]}',
                                        ),
                                        trailing: item.status != null
                                            ? Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: item.status == 'completed'
                                                      ? Colors.green
                                                      : item.status == 'pending'
                                                          ? Colors.orange
                                                          : Colors.red,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  item.status!,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            : null,
                                        onTap: () {
                                          // Chuyển đến màn hình chi tiết phân tích
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SkinAnalysisDetailScreen(analysisItem: item),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        const SizedBox(height: 24),
                        
                        // Nút thay đổi mật khẩu
                        ElevatedButton(
                          onPressed: () {
                            // Hiển thị dialog thay đổi mật khẩu
                            _showChangePasswordDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Thay đổi mật khẩu'),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Nút đăng xuất
                        ElevatedButton(
                          onPressed: () {
                            // Xử lý đăng xuất với AuthProvider
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Xác nhận đăng xuất'),
                                  content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop(); // Đóng hộp thoại
                                      },
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Gọi phương thức đăng xuất từ AuthProvider
                                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                        await authProvider.logout();
                                        Navigator.of(dialogContext).pop(); // Đóng hộp thoại
                                        // Chuyển về màn hình đăng nhập
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/login', // Route đến màn hình đăng nhập
                                          (route) => false, // Xóa toàn bộ stack
                                        );
                                      },
                                      child: const Text('Đăng xuất'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Đăng xuất'),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmNewPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thay đổi mật khẩu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu mới',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final oldPassword = oldPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmNewPassword = confirmNewPasswordController.text.trim();

                // Kiểm tra xác nhận mật khẩu
                if (newPassword != confirmNewPassword) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu mới không khớp'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Kiểm tra độ dài mật khẩu
                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu mới phải có ít nhất 6 ký tự'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Gọi phương thức thay đổi mật khẩu từ provider
                final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
                final success = await profileProvider.changePassword(oldPassword, newPassword);

                if (success) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Thay đổi mật khẩu thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(dialogContext).pop(); // Đóng dialog
                } else {
                  final errorMessage = profileProvider.errorMessage ?? 'Lỗi khi thay đổi mật khẩu';
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Đổi mật khẩu'),
            ),
          ],
        );
      },
    );
  }
}
}