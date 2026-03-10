import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../utils/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Privacy toggles
  bool _isPrivateAccount = false;
  bool _showActivityStatus = true;

  // Notification toggles
  bool _pushNotifications = true;
  bool _messageNotifications = true;
  bool _mentionNotifications = true;
  bool _likeNotifications = true;
  bool _commentNotifications = true;
  bool _followerNotifications = true;
  bool _liveNotifications = true;
  bool _notifyWhenLive = false;

  // Content & Media toggles
  bool _autoplayVideos = true;
  bool _dataSaver = false;
  bool _wifiOnlyDownload = false;

  // Security toggles
  bool _twoFactorAuth = false;

  // Live controls
  String _liveAudience = 'Everyone';

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: responsive.sp(24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: responsive.sp(18),
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: responsive.sp(8)),

          // ── ACCOUNT ──────────────────────────────────────────────────────
          _SectionHeader(title: 'Account', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => Navigator.pop(context, 'edit_profile'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.alternate_email,
              title: 'Username',
              trailing: '@adewale_johnson',
              onTap: () => _showComingSoon('Username'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.email_outlined,
              title: 'Email',
              trailing: 'adewale@example.com',
              onTap: () => _showComingSoon('Email'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.phone_outlined,
              title: 'Phone number',
              trailing: '+234 801 ••••••',
              onTap: () => _showComingSoon('Phone number'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Change password',
              onTap: () => _showComingSoon('Change password'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.no_accounts_outlined,
              title: 'Deactivate account',
              titleColor: AppTheme.alertOrange,
              onTap: () => _showDeactivateDialog(),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── PRIVACY ──────────────────────────────────────────────────────
          _SectionHeader(title: 'Privacy', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsToggle(
              icon: Icons.lock_outline,
              title: 'Private account',
              subtitle: 'Only approved followers can see your posts',
              value: _isPrivateAccount,
              onChanged: (v) => setState(() => _isPrivateAccount = v),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.block_outlined,
              title: 'Blocked accounts',
              onTap: () => _showComingSoon('Blocked accounts'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.volume_off_outlined,
              title: 'Muted accounts',
              onTap: () => _showComingSoon('Muted accounts'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.do_not_disturb_outlined,
              title: 'Restricted accounts',
              onTap: () => _showComingSoon('Restricted accounts'),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.visibility_outlined,
              title: 'Activity status',
              subtitle: 'Show when you were last active',
              value: _showActivityStatus,
              onChanged: (v) => setState(() => _showActivityStatus = v),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.auto_stories_outlined,
              title: 'Story controls',
              onTap: () => _showComingSoon('Story controls'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.live_tv_outlined,
              title: 'Live controls',
              trailing: _liveAudience,
              onTap: () => _showLiveAudienceSelector(),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── NOTIFICATIONS ─────────────────────────────────────────────────
          _SectionHeader(title: 'Notifications', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsToggle(
              icon: Icons.notifications_outlined,
              title: 'Push notifications',
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.message_outlined,
              title: 'Messages',
              value: _messageNotifications,
              onChanged: (v) => setState(() => _messageNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.alternate_email,
              title: 'Mentions',
              value: _mentionNotifications,
              onChanged: (v) => setState(() => _mentionNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.favorite_outline,
              title: 'Likes',
              value: _likeNotifications,
              onChanged: (v) => setState(() => _likeNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.comment_outlined,
              title: 'Comments',
              value: _commentNotifications,
              onChanged: (v) => setState(() => _commentNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.person_add_outlined,
              title: 'New followers',
              value: _followerNotifications,
              onChanged: (v) => setState(() => _followerNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.live_tv_outlined,
              title: 'Live notifications',
              value: _liveNotifications,
              onChanged: (v) => setState(() => _liveNotifications = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.radio_button_checked,
              title: 'Notify when someone goes live',
              value: _notifyWhenLive,
              onChanged: (v) => setState(() => _notifyWhenLive = v),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── CONTENT & MEDIA ───────────────────────────────────────────────
          _SectionHeader(title: 'Content & Media', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsToggle(
              icon: Icons.play_circle_outline,
              title: 'Autoplay videos',
              value: _autoplayVideos,
              onChanged: (v) => setState(() => _autoplayVideos = v),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.data_saver_on_outlined,
              title: 'Data saver',
              subtitle: 'Reduces data usage for videos and images',
              value: _dataSaver,
              onChanged: (v) => setState(() => _dataSaver = v),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.high_quality_outlined,
              title: 'Upload quality',
              trailing: 'High',
              onTap: () => _showComingSoon('Upload quality'),
              responsive: responsive,
            ),
            _SettingsToggle(
              icon: Icons.wifi_outlined,
              title: 'Download over Wi-Fi only',
              value: _wifiOnlyDownload,
              onChanged: (v) => setState(() => _wifiOnlyDownload = v),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Clear cache',
              onTap: () => _clearCache(),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── SECURITY ──────────────────────────────────────────────────────
          _SectionHeader(title: 'Security', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsToggle(
              icon: Icons.security_outlined,
              title: 'Two-factor authentication',
              subtitle: 'Add an extra layer of security',
              value: _twoFactorAuth,
              onChanged: (v) => setState(() => _twoFactorAuth = v),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.devices_outlined,
              title: 'Login activity',
              onTap: () => _showComingSoon('Login activity'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.phone_android_outlined,
              title: 'Saved devices',
              onTap: () => _showComingSoon('Saved devices'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.lock_reset_outlined,
              title: 'Change password',
              onTap: () => _showComingSoon('Change password'),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── SUPPORT ───────────────────────────────────────────────────────
          _SectionHeader(title: 'Support', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsTile(
              icon: Icons.flag_outlined,
              title: 'Report a problem',
              onTap: () => _showComingSoon('Report a problem'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.help_outline,
              title: 'Help center',
              onTap: () => _showComingSoon('Help center'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.groups_outlined,
              title: 'Community guidelines',
              onTap: () => _showComingSoon('Community guidelines'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.support_agent_outlined,
              title: 'Contact support',
              onTap: () => _showComingSoon('Contact support'),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          SizedBox(height: responsive.sp(8)),

          // ── ABOUT ─────────────────────────────────────────────────────────
          _SectionHeader(title: 'About', responsive: responsive),
          _SettingsGroup(children: [
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of service',
              onTap: () => _showComingSoon('Terms of service'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy policy',
              onTap: () => _showComingSoon('Privacy policy'),
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'App version',
              trailing: 'v${AppConstants.appVersion}',
              onTap: () {},
              responsive: responsive,
            ),
            _SettingsTile(
              icon: Icons.code_outlined,
              title: 'Open source licenses',
              onTap: () => _showComingSoon('Open source licenses'),
              responsive: responsive,
              showDivider: false,
            ),
          ]),

          // Logout — hidden at the very bottom as a small text button
          SizedBox(height: responsive.sp(24)),
          Center(
            child: TextButton(
              onPressed: _showLogoutDialog,
              child: Text(
                'Log out',
                style: TextStyle(
                  fontSize: responsive.sp(13),
                  color: AppTheme.greyMedium,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: responsive.sp(32)),
        ],
      ),
    );
  }

  // ── Dialogs & actions ────────────────────────────────────────────────────

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cache'),
        content: const Text('This will clear cached images and data. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.alertOrange)),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deactivate account'),
        content: const Text(
            'Your account will be hidden until you log back in. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Deactivate',
                style: TextStyle(color: AppTheme.alertOrange)),
          ),
        ],
      ),
    );
  }

  void _showLiveAudienceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final responsive = context.responsive;
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(20))),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: responsive.sp(12)),
                Container(
                  width: responsive.sp(40), height: responsive.sp(4),
                  decoration: BoxDecoration(
                    color: AppTheme.greyMedium.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(responsive.sp(20)),
                  child: Text('Who can join your live?',
                    style: TextStyle(fontSize: responsive.sp(16), fontWeight: FontWeight.w700)),
                ),
                for (final option in ['Everyone', 'Followers', 'Friends only'])
                  ListTile(
                    title: Text(option),
                    trailing: _liveAudience == option
                        ? const Icon(Icons.check, color: AppTheme.greenPrimary)
                        : null,
                    onTap: () {
                      setState(() => _liveAudience = option);
                      Navigator.pop(ctx);
                    },
                  ),
                SizedBox(height: responsive.sp(12)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Log out',
                style: TextStyle(color: AppTheme.greyMedium,
                    fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Settings Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Responsive responsive;

  const _SectionHeader({required this.title, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.sp(16), responsive.sp(4), responsive.sp(16), responsive.sp(8)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: responsive.sp(13),
          fontWeight: FontWeight.w600,
          color: AppTheme.greyMedium,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? titleColor;
  final VoidCallback onTap;
  final Responsive responsive;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    required this.onTap,
    required this.responsive,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(icon, size: responsive.sp(22), color: titleColor ?? AppTheme.textPrimary),
          title: Text(
            title,
            style: TextStyle(
              fontSize: responsive.sp(15),
              fontWeight: FontWeight.w500,
              color: titleColor ?? AppTheme.textPrimary,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                Text(trailing!,
                    style: TextStyle(
                        fontSize: responsive.sp(13), color: AppTheme.greyMedium)),
              SizedBox(width: responsive.sp(4)),
              Icon(Icons.chevron_right, size: responsive.sp(20), color: AppTheme.greyMedium),
            ],
          ),
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.sp(16), vertical: responsive.sp(2)),
        ),
        if (showDivider)
          Divider(
            height: 1, thickness: 1,
            indent: responsive.sp(56),
            color: AppTheme.greySoft,
          ),
      ],
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Responsive responsive;
  final bool showDivider;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.responsive,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(icon, size: responsive.sp(22), color: AppTheme.textPrimary),
          title: Text(title,
              style: TextStyle(
                  fontSize: responsive.sp(15), fontWeight: FontWeight.w500)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: TextStyle(
                      fontSize: responsive.sp(12), color: AppTheme.greyMedium))
              : null,
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.greenPrimary,
            activeTrackColor: AppTheme.greenPrimary.withOpacity(0.4),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.sp(16), vertical: responsive.sp(2)),
        ),
        if (showDivider)
          Divider(
            height: 1, thickness: 1,
            indent: responsive.sp(56),
            color: AppTheme.greySoft,
          ),
      ],
    );
  }
}
