import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/report.dart';
import '../models/comment.dart';
import '../providers/report_provider.dart';
import '../widgets/risk_level_badge.dart';
import '../widgets/comment_list.dart';

class ReportDetailScreen extends StatefulWidget {
  final Report report;
  
  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoadingComments = false;
  bool _isPostingComment = false;
  
  @override
  void initState() {
    super.initState();
    _loadComments();
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  
  Future<void> _loadComments() async {
    if (_isLoadingComments) return;
    
    setState(() {
      _isLoadingComments = true;
    });
    
    try {
      await Provider.of<ReportProvider>(context, listen: false)
          .fetchComments(widget.report.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading comments'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
        });
      }
    }
  }
  
  Future<void> _postComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    
    setState(() {
      _isPostingComment = true;
    });
    
    try {
      await Provider.of<ReportProvider>(context, listen: false)
          .addComment(widget.report.id, comment);
      
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error posting comment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final comments = reportProvider.getCommentsForReport(widget.report.id);
    final report = reportProvider.getReportById(widget.report.id) ?? widget.report;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pest image
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      report.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Report details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User info and timestamp
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: report.userAvatarUrl != null
                                  ? NetworkImage(report.userAvatarUrl!)
                                  : null,
                              child: report.userAvatarUrl == null
                                  ? Text(report.userName.substring(0, 1).toUpperCase())
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    timeago.format(report.timestamp),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (report.isVerified)
                              Tooltip(
                                message: 'Verified by agricultural expert',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Pest identification and risk level
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                report.pestName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            RiskLevelBadge(riskLevel: report.riskLevel),
                          ],
                        ),
                        
                        if (report.pestScientificName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              report.pestScientificName!,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        
                        if (report.location != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    report.location!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Description
                        if (report.description != null && report.description!.isNotEmpty)
                          Text(
                            report.description!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Action bar
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                report.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: report.isLiked ? Colors.red : null,
                                size: 28,
                              ),
                              onPressed: () {
                                Provider.of<ReportProvider>(context, listen: false)
                                    .toggleLike(report.id);
                              },
                              tooltip: 'Like',
                            ),
                            Text(
                              report.likeCount.toString(),
                              style: TextStyle(
                                color: report.isLiked ? Colors.red : Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Icon(
                              Icons.comment,
                              size: 24,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              report.commentCount.toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        
                        const Divider(height: 32),
                        
                        // Comments section
                        const Text(
                          'Comments',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  
                  // Comments list
                  _isLoadingComments
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : CommentList(comments: comments),
                  
                  // Extra space at bottom
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // Comment input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: _isPostingComment
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: _isPostingComment ? null : _postComment,
                  color: Theme.of(context).primaryColor,
                  tooltip: 'Post Comment',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

