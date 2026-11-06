import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../widgets/incident_card.dart';
import '../widgets/profile_avatar.dart';
import 'incident_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onReport;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onCategory;
  const HomeScreen(
      {super.key, required this.onReport, required this.onSeeAll, required this.onCategory});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final inc = context.watch<IncidentProvider>();
    final scheme = Theme.of(context).colorScheme;
    final mine = inc.mine(user.uid);
    // Staff see totals for every report; students see their own
    final scope = user.isStaff ? inc.all : mine;
    int count(String s) => scope.where((i) => i.status == s).length;
    final recent = (user.isStaff ? inc.all : mine).take(3).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Hello, ${user.name.split(' ').first} 👋',
                    style: Theme.of(context).textTheme.headlineSmall),
                Text('Report issues and track their resolution.',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ]),
            ),
            ProfileAvatar(name: user.name, radius: 22),
          ]),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('See an issue on campus?',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Report it and help improve our learning environment.',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                onPressed: onReport,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Report an Issue'),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Report Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(children: [
            _StatTile('${scope.length}', user.isStaff ? 'All Reports' : 'My Reports',
                Icons.description_outlined, scheme.primary),
            _StatTile('${count('in_progress')}', 'In Progress', Icons.schedule, statusColor('in_progress')),
            _StatTile('${count('resolved')}', 'Resolved', Icons.check_circle_outline, const Color(0xFF2E9E5B)),
            _StatTile('${count('submitted')}', 'Submitted', Icons.error_outline, const Color(0xFFD99100)),
          ]),
          const SizedBox(height: 24),
          Text('Browse by category', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 84,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: incidentCategories
                  .map((c) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => onCategory(c.key),
                          child: Container(
                            width: 84,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: categoryGradient(c.key),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(c.icon, color: Colors.white, size: 28),
                                  const SizedBox(height: 6),
                                  Text(c.label,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ]),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                child: Text(user.isStaff ? 'Recent Reports (all)' : 'Recent Reports',
                    style: Theme.of(context).textTheme.titleMedium)),
            TextButton(onPressed: onSeeAll, child: const Text('See all')),
          ]),
          if (inc.loadingList)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
          else if (recent.isEmpty)
            Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                    child: Text(inc.error ?? 'No reports yet.', textAlign: TextAlign.center)))
          else
            ...recent.map((i) => IncidentCard(
                  incident: i,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => IncidentDetailsScreen(incidentId: i.id))),
                )),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatTile(this.value, this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
