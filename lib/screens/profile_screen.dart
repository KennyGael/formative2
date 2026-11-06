import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final inc = context.watch<IncidentProvider>();
    final user = auth.user!;
    final mine = inc.mine(user.uid);
    final scope = user.isStaff ? inc.all : mine;
    int count(String s) => scope.where((i) => i.status == s).length;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(children: [
              const SizedBox(height: 8),
              ProfileAvatar(name: user.name, radius: 44),
              const SizedBox(height: 12),
              Text(user.name,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(user.email, style: const TextStyle(color: Colors.white70)),
              if (kDebugMode) ...[
                const SizedBox(height: 4),
                // Debug only: compare this with the Document ID in Firestore > users
                SelectableText('UID: ${user.uid}  (role: ${user.role})',
                    style: const TextStyle(color: Colors.white60, fontSize: 10)),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(user.isStaff ? Icons.verified_user_outlined : Icons.school_outlined,
                      size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(user.isStaff ? 'Campus staff' : 'Student',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ]),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              _MiniStat('${scope.length}', user.isStaff ? 'All reports' : 'My reports', AppColors.primary),
              _MiniStat('${count('in_progress')}', 'In progress', statusColor('in_progress')),
              _MiniStat('${count('resolved')}', 'Resolved', statusColor('resolved')),
            ]),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.badge_outlined, color: AppColors.primary),
                title: Text(user.isStaff ? 'Staff access' : 'Student access'),
                subtitle: Text(user.isStaff
                    ? 'Review all reports and update their status'
                    : 'Submit reports and track their progress'),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ]),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12)),
        ]),
      ),
    );
  }
}
