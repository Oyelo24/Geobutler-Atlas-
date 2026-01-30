import 'package:flutter/material.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoSync = true;
  bool _offlineMode = false;
  String _units = 'metric';
  String _coordinateFormat = 'decimal';
  String _theme = 'system';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'Settings',
        subtitle: 'Customize your experience',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            _buildSectionHeader('APPEARANCE'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSettingItem(
                icon: _getThemeIcon(),
                title: 'Theme',
                subtitle: _getThemeLabel(),
                onTap: () => _showThemeDialog(),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.palette_outlined,
                title: 'App Color',
                subtitle: 'Teal (Default)',
                onTap: () => _showColorDialog(),
              ),
            ]),

            const SizedBox(height: 24),

            // Survey Preferences
            _buildSectionHeader('SURVEY PREFERENCES'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.straighten,
                title: 'Units',
                subtitle: _units == 'metric' ? 'Metric (m, km)' : 'Imperial (ft, mi)',
                onTap: () => _showUnitsDialog(),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.public,
                title: 'Coordinate Format',
                subtitle: _getCoordinateFormatLabel(),
                onTap: () => _showCoordinateDialog(),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.gps_fixed,
                title: 'GPS Settings',
                subtitle: 'Accuracy thresholds & filters',
                onTap: () => _showGPSSettings(),
              ),
            ]),

            const SizedBox(height: 24),

            // Data & Sync
            _buildSectionHeader('DATA & SYNC'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.sync,
                title: 'Auto Sync',
                subtitle: 'Automatically sync data when online',
                trailing: Switch(
                  value: _autoSync,
                  onChanged: (value) => setState(() => _autoSync = value),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.offline_bolt,
                title: 'Offline Mode',
                subtitle: 'Work without internet connection',
                trailing: Switch(
                  value: _offlineMode,
                  onChanged: (value) => setState(() => _offlineMode = value),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.backup,
                title: 'Backup Data',
                subtitle: 'Export projects and settings',
                onTap: () => _showBackupDialog(),
              ),
            ]),

            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader('NOTIFICATIONS'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Get notified about important updates',
                trailing: Switch(
                  value: _notifications,
                  onChanged: (value) => setState(() => _notifications = value),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.warning_outlined,
                title: 'Data Quality Alerts',
                subtitle: 'Notify when accuracy drops',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader('ABOUT'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About GeoButler',
                subtitle: 'Professional surveying companion',
                onTap: () => Navigator.pushNamed(context, '/about-geobutler'),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.smart_toy_outlined,
                title: 'About Atlas',
                subtitle: 'AI surveying assistant',
                onTap: () => Navigator.pushNamed(context, '/about-atlas'),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Documentation and tutorials',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
              ),
            ]),

            const SizedBox(height: 32),

            // Version Info
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'GeoButler',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0 (Build 1)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mutedColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Powered by Atlas AI',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mutedColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Measure with confidence',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  IconData _getThemeIcon() {
    switch (_theme) {
      case 'light': return Icons.light_mode;
      case 'dark': return Icons.dark_mode;
      default: return Icons.brightness_auto;
    }
  }

  String _getThemeLabel() {
    switch (_theme) {
      case 'light': return 'Light';
      case 'dark': return 'Dark';
      default: return 'System';
    }
  }

  String _getCoordinateFormatLabel() {
    switch (_coordinateFormat) {
      case 'decimal': return 'Decimal Degrees';
      case 'dms': return 'Degrees Minutes Seconds';
      case 'utm': return 'UTM Coordinates';
      default: return 'Decimal Degrees';
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('System', 'system', _theme, (value) {
              setState(() => _theme = value!);
              _applyTheme(value!);
              Navigator.pop(context);
            }),
            _buildRadioOption('Light', 'light', _theme, (value) {
              setState(() => _theme = value!);
              _applyTheme(value!);
              Navigator.pop(context);
            }),
            _buildRadioOption('Dark', 'dark', _theme, (value) {
              setState(() => _theme = value!);
              _applyTheme(value!);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _applyTheme(String theme) {
    // Apply theme change to the app
    // This would typically update a theme provider
    if (theme == 'dark') {
      // Switch to dark theme
    } else if (theme == 'light') {
      // Switch to light theme  
    } else {
      // Use system theme
    }
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('Metric (m, km)', 'metric', _units, (value) {
              setState(() => _units = value!);
              Navigator.pop(context);
            }),
            _buildRadioOption('Imperial (ft, mi)', 'imperial', _units, (value) {
              setState(() => _units = value!);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showCoordinateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coordinate Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('Decimal Degrees', 'decimal', _coordinateFormat, (value) {
              setState(() => _coordinateFormat = value!);
              Navigator.pop(context);
            }),
            _buildRadioOption('Degrees Minutes Seconds', 'dms', _coordinateFormat, (value) {
              setState(() => _coordinateFormat = value!);
              Navigator.pop(context);
            }),
            _buildRadioOption('UTM Coordinates', 'utm', _coordinateFormat, (value) {
              setState(() => _coordinateFormat = value!);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showColorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Color'),
        content: const Text('Color customization will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showGPSSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accuracy Thresholds:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Good: ≤ 3m horizontal'),
            Text('• Fair: ≤ 8m horizontal'),
            Text('• Poor: > 8m horizontal'),
            SizedBox(height: 16),
            Text('Advanced GPS settings will be available in a future update.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Data'),
        content: const Text('Data backup and export features will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutGeoButler() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About GeoButler'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GeoButler is a professional surveying companion app designed to streamline field data collection and analysis.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text('Key Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• GPS data collection with accuracy tracking'),
            Text('• Project management and organization'),
            Text('• Real-time mapping and visualization'),
            Text('• AI-powered surveying assistance'),
            Text('• Offline capability for remote work'),
            SizedBox(height: 16),
            Text(
              'Built for surveyors, by surveyors.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutAtlas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Atlas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atlas is your AI surveying assistant, powered by advanced machine learning to provide expert guidance and analysis.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text('Atlas can help with:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Technical surveying questions'),
            Text('• Data quality analysis'),
            Text('• Equipment recommendations'),
            Text('• Best practice guidance'),
            Text('• Project planning assistance'),
            Text('• Legal and regulatory compliance'),
            SizedBox(height: 16),
            Text(
              'Ask Atlas anything about surveying - from basic GPS questions to complex boundary law.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Help documentation and video tutorials will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your privacy is important to us. GeoButler is designed with privacy in mind:',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text('• All survey data stays on your device'),
            Text('• No personal information is collected'),
            Text('• Optional cloud sync is encrypted'),
            Text('• No tracking or analytics'),
            Text('• Open source and transparent'),
            SizedBox(height: 16),
            Text(
              'Full privacy policy available at geobutler.com/privacy',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption<T>(String title, T value, T groupValue, ValueChanged<T?> onChanged) {
    return RadioListTile<T>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.mutedColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: AppTheme.mutedColor, size: 20),
          ],
        ),
      ),
    );
  }
}
