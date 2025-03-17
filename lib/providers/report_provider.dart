import 'package:flutter/material.dart';
import 'dart:io';
import '../models/report.dart';
import '../models/comment.dart';
import '../models/pest.dart';
import '../services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  
  List<Report> _reports = [];
  final Map<String, List<Comment>> _comments = {};
  bool _hasMore = true;
  
  List<Report> get reports => [..._reports];
  bool get hasMore => _hasMore;
  
  Report? getReportById(String id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Comment> getCommentsForReport(String reportId) {
    return _comments[reportId] ?? [];
  }
  
  Future<void> fetchReports({
    String filter = 'all',
    String sort = 'recent',
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      _reports = [];
      _hasMore = true;
    }
    
    if (!_hasMore) return;
    
    final newReports = await _reportService.getReports(
      offset: _reports.length,
      limit: 10,
      filter: filter,
      sort: sort,
    );
    
    if (newReports.isEmpty) {
      _hasMore = false;
    } else {
      _reports.addAll(newReports);
    }
    
    notifyListeners();
  }
  
  Future<void> fetchComments(String reportId) async {
    final comments = await _reportService.getComments(reportId);
    _comments[reportId] = comments;
    notifyListeners();
  }
  
  Future<void> toggleLike(String reportId) async {
    final reportIndex = _reports.indexWhere((report) => report.id == reportId);
    if (reportIndex == -1) return;
    
    final report = _reports[reportIndex];
    final updatedReport = report.copyWith(
      isLiked: !report.isLiked,
      likeCount: report.isLiked ? report.likeCount - 1 : report.likeCount + 1,
    );
    
    _reports[reportIndex] = updatedReport;
    notifyListeners();
    
    try {
      await _reportService.likeReport(reportId, !report.isLiked);
    } catch (e) {
      // Revert on error
      _reports[reportIndex] = report;
      notifyListeners();
    }
  }
  
  Future<void> addComment(String reportId, String text) async {
    final comment = await _reportService.addComment(reportId, text);
    
    if (_comments.containsKey(reportId)) {
      _comments[reportId]!.insert(0, comment);
    } else {
      _comments[reportId] = [comment];
    }
    
    // Update comment count in report
    final reportIndex = _reports.indexWhere((report) => report.id == reportId);
    if (reportIndex != -1) {
      final report = _reports[reportIndex];
      _reports[reportIndex] = report.copyWith(
        commentCount: report.commentCount + 1,
      );
    }
    
    notifyListeners();
  }
  
  Future<void> createReport({
    required File imageFile,
    required Pest pest,
    String? description,
    String? location,
  }) async {
    final report = await _reportService.createReport(
      imageFile: imageFile,
      pestName: pest.name,
      pestScientificName: pest.scientificName,
      riskLevel: pest.riskLevel,
      description: description,
      location: location,
    );
    
    _reports.insert(0, report);
    notifyListeners();
  }
}

