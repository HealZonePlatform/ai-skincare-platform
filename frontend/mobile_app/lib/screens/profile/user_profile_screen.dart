// lib/screens/profile/user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ai_skincare_platform/providers/user_profile_provider.dart';
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
                onPressed: () => _handleEditProfile(context, profileProvider, userProfile),
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
                      _buildAvatarSection(context, userProfile),
                      const SizedBox(height: 16),
                      _buildProfileForm(userProfile),
                      const SizedBox(height: 24),
                      const Text(
                        'Lịch sử phân tích da',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAnalysisHistory(profileProvider, history),
                      const SizedBox(height: 24),
                      _buildChangePasswordButton(context),
                      const SizedBox(height: 16),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ✅ FIXED: Extract to method to avoid async gap
  void _handleEditProfile(
    BuildContext context,
    UserProfileProvider profileProvider,
    dynamic userProfile,
  ) {
    if (_isEditing) {
      if (_formKey.currentState!.validate()) {
        profileProvider
            .updateUserProfile(
          fullName: _fullNameController.text,
          phoneNumber: _phoneNumberController.text,
        )
            .then((success) {
          if (!mounted) return;
          
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
      _fullNameController.text = userProfile?.fullName ?? '';
      _phoneNumberController.text = userProfile?.phoneNumber ?? '';
      setState(() {
        _isEditing = true;
      });
    }
  }

  Widget _buildAvatarSection(BuildContext context, dynamic userProfile) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
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
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 40,
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
    );
  }

  Widget _buildProfileForm(dynamic userProfile) {
    return Form(
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
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisHistory(UserProfileProvider profileProvider, List<dynamic> history) {
    if (profileProvider.isLoading && history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Chưa có lịch sử phân tích da',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
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
            onTap: () => _navigateToDetail(context, item),
          ),
        );
      },
    );
  }

  // ✅ FIXED: Extract navigation to avoid async gap
  void _navigateToDetail(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkinAnalysisDetailScreen(analysisItem: item),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showChangePasswordDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text('Thay đổi mật khẩu'),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text('Đăng xuất'),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => _performLogout(dialogContext),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  // ✅ FIXED: Extract logout logic to avoid async gap
  void _performLogout(BuildContext dialogContext) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    if (!mounted) return;
    
    Navigator.of(dialogContext).pop();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => _performPasswordChange(
                dialogContext,
                oldPasswordController.text.trim(),
                newPasswordController.text.trim(),
                confirmNewPasswordController.text.trim(),
              ),
              child: const Text('Đổi mật khẩu'),
            ),
          ],
        );
      },
    );
  }

  // ✅ FIXED: Extract password change logic to avoid async gap
  void _performPasswordChange(
    BuildContext dialogContext,
    String oldPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    // Validate passwords
    if (newPassword != confirmNewPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới phải có ít nhất 6 ký tự'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    final success = await profileProvider.changePassword(oldPassword, newPassword);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text('Thay đổi mật khẩu thành công'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(dialogContext).pop();
    } else {
      final errorMessage = profileProvider.errorMessage ?? 'Lỗi khi thay đổi mật khẩu';
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
