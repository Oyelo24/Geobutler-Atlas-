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
  String _units = 'metric';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'Settings',
            subtitle: 'Customize your experience',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  _buildSectionHeader('APPEARANCE'),
                  const SizedBox(height: 12),
                  _buildSettingsCard([
                    _buildSettingItem(
                      icon: _darkMode ? Icons.dark_mode : Icons.light_mode,
                      title: 'Dark Mode',
                      subtitle: _darkMode ? 'On' : 'Off',
                      trailing: Switch(
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Preferences Section
                  _buildSectionHeader('PREFERENCES'),
                  const SizedBox(height: 12),
                  _buildSettingsCard([
                    _buildSettingItem(
                      icon: Icons.straighten,
                      title: 'Units',
                      subtitle: _units == 'metric'
                          ? 'Metric (m, km)'
                          : 'Imperial (ft, mi)',
                      onTap: () {
                        setState(() {
                          _units = _units == 'metric' ? 'imperial' : 'metric';
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      icon: Icons.public,
                      title: 'Coordinate Format',
                      subtitle: 'Decimal Degrees',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: _notifications ? 'Enabled' : 'Disabled',
                      trailing: Switch(
                        value: _notifications,
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                        },
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Accuracy Thresholds Section
                  _buildSectionHeader('ACCURACY THRESHOLDS'),
                  const SizedBox(height: 12),
                  _buildSettingsCard([
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildAccuracyRow(
                              'Good', '≤ 3 cm', AppTheme.successColor),
                          const SizedBox(height: 12),
                          _buildAccuracyRow(
                              'Fair', '≤ 8 cm', AppTheme.warningColor),
                          const SizedBox(height: 12),
                          _buildAccuracyRow(
                              'Poor', '> 8 cm', AppTheme.destructiveColor),
                        ],
                      ),
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
                      subtitle: 'Version 1.0.0',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      icon: Icons.smart_toy_outlined,
                      title: 'About Atlas',
                      subtitle: 'Your AI surveying assistant',
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Branding
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'GeoButler',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Powered by Atlas',
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
                            color: AppTheme.mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
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
      child: Column(
        children: children,
      ),
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
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.mutedColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppTheme.mutedColor,
              ),
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
                  if (subtitle.isNotEmpty) ...[],
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
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.mutedColor,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyRow(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'monospace',
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
