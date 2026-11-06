import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../widgets/incident_card.dart';
import 'incident_details_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inc = context.watch<IncidentProvider>();
    final items = inc.filtered;

    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _search,
            onChanged: inc.setQuery,
            decoration: InputDecoration(
              hintText: 'Search reports',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _search.clear();
                        inc.setQuery('');
                      }),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        _FilterRow(
          options: [null, ...statuses],
          selected: inc.statusFilter,
          label: (v) => v == null ? 'All' : statusLabel(v),
          onSelected: inc.setStatusFilter,
        ),
        _FilterRow(
          options: [null, ...incidentCategories.map((c) => c.key)],
          selected: inc.categoryFilter,
          label: (v) => v == null ? 'All categories' : categoryFor(v).label,
          onSelected: inc.setCategoryFilter,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: inc.loadingList
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(inc.error ?? 'No reports match your search.',
                              textAlign: TextAlign.center)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      itemBuilder: (_, i) => IncidentCard(
                        incident: items[i],
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    IncidentDetailsScreen(incidentId: items[i].id))),
                      ),
                    ),
        ),
      ]),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final List<String?> options;
  final String? selected;
  final String Function(String?) label;
  final ValueChanged<String?> onSelected;
  const _FilterRow(
      {required this.options, required this.selected, required this.label, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: options
            .map((o) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(label(o)),
                    selected: selected == o,
                    onSelected: (_) => onSelected(o),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
