import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticatedState) {
            return const SizedBox.shrink();
          }
          final user = authState.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── User card ─────────────────────────
                _UserCard(
                  fullName: user.fullName,
                  username: user.username,
                  email: user.email,
                ),
                const SizedBox(height: 24),

                _SectionHeader(label: 'Preferences'),
                const SizedBox(height: 10),

                // ── Theme toggle ──────────────────────
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return _SettingsGroup(
                      children: [
                        _SettingsRow(
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          iconBgColor: const Color(0xFF6C63FF),
                          title: isDark ? 'Dark Mode' : 'Light Mode',
                          subtitle: 'Currently ${isDark ? 'dark' : 'light'}',
                          trailing: Switch(
                            value: isDark,
                            onChanged: (_) =>
                                context.read<ThemeCubit>().toggleTheme(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                _SectionHeader(label: 'Account'),
                const SizedBox(height: 10),

                // ── Account group ─────────────────────
                _SettingsGroup(
                  children: [
                    _SettingsRow(
                      icon: Icons.person_outline_rounded,
                      iconBgColor: const Color(0xFF6C63FF),
                      title: 'Account Info',
                      subtitle: 'View your profile',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.appColors.textSecondary,
                      ),
                      onTap: () {
                        _showAccountInfoSheet(context, user.fullName,
                            user.username, user.email, user.gender);
                      },
                    ),
                    _DividerRow(),
                    _SettingsRow(
                      icon: Icons.notifications_none_rounded,
                      iconBgColor: const Color(0xFF43E97B),
                      title: 'Notifications',
                      subtitle: 'App preferences',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionHeader(label: 'Session'),
                const SizedBox(height: 10),

                // ── Logout ────────────────────────────
                _SettingsGroup(
                  children: [
                    _SettingsRow(
                      icon: Icons.logout_rounded,
                      iconBgColor: const Color(0xFFFF6584),
                      title: 'Sign Out',
                      subtitle: 'Clear session and logout',
                      titleColor: const Color(0xFFFF6584),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.appColors.textSecondary,
                      ),
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                _AppVersion(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const AuthLogoutEvent());
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF6584),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showAccountInfoSheet(
    BuildContext context,
    String name,
    String username,
    String email,
    String gender,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AccountInfoSheet(
        name: name,
        username: username,
        email: email,
        gender: gender,
      ),
    );
  }
}

// ── User Card ──────────────────────────────────────────────────
class _UserCard extends StatelessWidget {
  final String fullName;
  final String username;
  final String email;

  const _UserCard({
    required this.fullName,
    required this.username,
    required this.email,
  });

  String get _initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.12),
            theme.colorScheme.secondary.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: theme.textTheme.titleLarge),
                const SizedBox(height: 3),
                Text(
                  '@$username',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 12,
                      color: appColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 11,
                          color: appColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: appColors.textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ── Settings Group ─────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ── Settings Row ───────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: iconBgColor.withOpacity(0.2)),
              ),
              child: Icon(icon, color: iconBgColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Divider(color: appColors.border, height: 1),
    );
  }
}

// ── Account Info Bottom Sheet ──────────────────────────────────
class _AccountInfoSheet extends StatelessWidget {
  final String name;
  final String username;
  final String email;
  final String gender;

  const _AccountInfoSheet({
    required this.name,
    required this.username,
    required this.email,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Account Details', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          _InfoRow(icon: Icons.badge_outlined, label: 'Full Name', value: name),
          _InfoRow(
            icon: Icons.alternate_email_rounded,
            label: 'Username',
            value: '@$username',
          ),
          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Gender',
            value: gender,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: appColors.textSecondary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: appColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(value, style: theme.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Center(
      child: Column(
        children: [
          Icon(Icons.local_offer_rounded,
              size: 24, color: appColors.textSecondary),
          const SizedBox(height: 6),
          Text(
            'Taghyeer v1.0.0',
            style: TextStyle(fontSize: 12, color: appColors.textSecondary),
          ),
          Text(
            'Taghyeer Technologies',
            style: TextStyle(fontSize: 11, color: appColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
