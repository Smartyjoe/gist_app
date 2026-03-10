import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final UserProfile _user = UserProfile(
    id: 'user1',
    name: 'Adewale Johnson',
    avatar: 'https://i.pravatar.cc/150?img=1',
    bio: 'Community reporter from Lagos, Nigeria. Committed to making our neighborhoods safer.',
    location: 'Lagos, Nigeria',
    email: 'adewale.johnson@example.com',
    phone: '+234 801 234 5678',
    preferredLanguage: 'en',
    postsCount: 45,
    followersCount: 1234,
    followingCount: 567,
    reportsCount: 38,
    isVerified: true,
    joinedAt: DateTime(2023, 1, 15),
  );

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: responsive.sp(24)),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(responsive),
            
            SizedBox(height: responsive.sp(AppTheme.spacing16)),
            
            // Stats
            _buildStats(responsive),
            
            SizedBox(height: responsive.sp(AppTheme.spacing16)),
            
            // Menu Items
            _buildMenuItem(
              icon: Icons.person,
              title: 'Edit Profile',
              onTap: _editProfile,
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.article,
              title: 'My Reports',
              onTap: () {},
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.bookmark,
              title: 'Saved Posts',
              onTap: () {},
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: 'Language',
              trailing: _getLanguageName(_user.preferredLanguage),
              onTap: _changeLanguage,
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: 'Notification Settings',
              onTap: () {},
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip,
              title: 'Privacy & Safety',
              onTap: () {},
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {},
              responsive: responsive,
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'About',
              trailing: 'v${AppConstants.appVersion}',
              onTap: () {},
              responsive: responsive,
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing16)),
            
            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.sp(AppTheme.spacing16),
              ),
              child: OutlinedButton(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.alertOrange,
                  side: const BorderSide(color: AppTheme.alertOrange),
                  minimumSize: Size(double.infinity, responsive.sp(48)),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: responsive.sp(16)),
                ),
              ),
            ),
            
            SizedBox(height: responsive.sp(AppTheme.spacing32)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.all(responsive.sp(AppTheme.spacing20)),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: responsive.sp(50),
                backgroundImage: _user.avatar != null
                    ? NetworkImage(_user.avatar!)
                    : null,
                backgroundColor: AppTheme.greySoft,
                child: _user.avatar == null
                    ? Icon(
                        Icons.person,
                        size: responsive.sp(50),
                        color: AppTheme.greyMedium,
                      )
                    : null,
              ),
              if (_user.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(responsive.sp(4)),
                    decoration: const BoxDecoration(
                      color: AppTheme.greenPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppTheme.white,
                      size: responsive.sp(16),
                    ),
                  ),
                ),
            ],
          ),
          
          SizedBox(height: responsive.sp(AppTheme.spacing12)),
          
          // Name
          Text(
            _user.name,
            style: TextStyle(
              fontSize: responsive.sp(20),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          
          SizedBox(height: responsive.sp(AppTheme.spacing4)),
          
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: responsive.sp(16),
                color: AppTheme.textSecondary,
              ),
              SizedBox(width: responsive.sp(4)),
              Text(
                _user.location ?? 'Location not set',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          
          if (_user.bio != null) ...[
            SizedBox(height: responsive.sp(AppTheme.spacing12)),
            Text(
              _user.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        vertical: responsive.sp(AppTheme.spacing20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Posts', _user.postsCount, responsive),
          _buildStatItem('Reports', _user.reportsCount, responsive),
          _buildStatItem('Followers', _user.followersCount, responsive),
          _buildStatItem('Following', _user.followingCount, responsive),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Responsive responsive) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: responsive.sp(20),
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: responsive.sp(4)),
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.sp(12),
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    required Responsive responsive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.sp(1)),
      color: AppTheme.white,
      child: ListTile(
        leading: Icon(
          icon,
          size: responsive.sp(24),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.sp(15),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  color: AppTheme.textSecondary,
                ),
              ),
            SizedBox(width: responsive.sp(8)),
            Icon(
              Icons.chevron_right,
              size: responsive.sp(24),
              color: AppTheme.greyMedium,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _getLanguageName(String code) {
    final lang = AppConstants.supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => AppConstants.supportedLanguages[0],
    );
    return lang.nativeName;
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening settings...')),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile...')),
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.supportedLanguages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang.nativeName),
              subtitle: Text(lang.name),
              value: lang.code,
              groupValue: _user.preferredLanguage,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Language changed to ${lang.nativeName}')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertOrange,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
