import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/report.dart';
import '../providers/report_provider.dart';
import '../widgets/report_card.dart';
import '../widgets/filter_chip_bar.dart';
import 'report_detail_screen.dart';
import 'create_report_screen.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  String _selectedFilter = 'all';
  String _selectedSort = 'recent';
  bool _isLoading = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ReportProvider>(context, listen: false)
          .fetchReports(filter: _selectedFilter, sort: _selectedSort);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading reports'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshReports() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await Provider.of<ReportProvider>(context, listen: false)
          .fetchReports(filter: _selectedFilter, sort: _selectedSort, forceRefresh: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error refreshing feed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _onFilterChanged(String filter) {
    if (filter != _selectedFilter) {
      setState(() {
        _selectedFilter = filter;
      });
      _loadReports();
    }
  }

  void _onSortChanged(String sort) {
    if (sort != _selectedSort) {
      setState(() {
        _selectedSort = sort;
      });
      _loadReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reports = reportProvider.reports;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              _showSortOptions(context);
            },
            tooltip: 'Sort Options',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          FilterChipBar(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
          
          // Main content
          Expanded(
            child: _isLoading && reports.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshReports,
                    child: reports.isEmpty
                        ? _buildEmptyState(context)
                        : _buildReportsList(reports),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateReportScreen(),
            ),
          ).then((_) => _refreshReports());
        },
        tooltip: 'Share Identification',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bug_report_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Reports Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share a pest identification with the community!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateReportScreen(),
                  ),
                ).then((_) => _refreshReports());
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Share Identification'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsList(List<Report> reports) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: reports.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == reports.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final report = reports[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReportCard(
            report: report,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailScreen(report: report),
                ),
              );
            },
            onLike: () {
              Provider.of<ReportProvider>(context, listen: false)
                  .toggleLike(report.id);
            },
          ),
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSortOption(
                context,
                'recent',
                'Most Recent',
                Icons.access_time,
              ),
              _buildSortOption(
                context,
                'popular',
                'Most Popular',
                Icons.favorite,
              ),
              _buildSortOption(
                context,
                'comments',
                'Most Discussed',
                Icons.comment,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedSort == value;
    
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _onSortChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

