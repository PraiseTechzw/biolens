import 'dart:io';
import 'dart:math';
import '../models/report.dart';
import '../models/comment.dart';
import '../models/pest.dart';

class ReportService {
  // In a real app, this would be a backend API service
  // For demo purposes, we'll generate mock data
  
  final List<String> _userNames = [
    'John Moyo',
    'Sarah Ndlovu',
    'Michael Chigumba',
    'Grace Mutasa',
    'David Ncube',
    'Tendai Mhere',
    'Blessing Chikwanda',
    'Tatenda Zulu',
  ];
  
  final List<String> _locations = [
    'Harare, Zimbabwe',
    'Bulawayo, Zimbabwe',
    'Mutare, Zimbabwe',
    'Gweru, Zimbabwe',
    'Masvingo, Zimbabwe',
    'Chinhoyi, Zimbabwe',
    'Victoria Falls, Zimbabwe',
  ];
  
  final List<String> _pestImages = [
    'https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=800',
    'https://images.unsplash.com/photo-1567793736005-599e0fc30f21?w=800',
    'https://images.unsplash.com/photo-1575464362889-a91af6b25e89?w=800',
    'https://images.unsplash.com/photo-1611692475329-c1c9a9f80e7b?w=800',
    'https://images.unsplash.com/photo-1634138235740-a37a1d1e0f8a?w=800',
  ];
  
  final List<String> _commentTexts = [
    'I saw this pest in my garden too!',
    'Thanks for sharing, this is helpful.',
    'Is this dangerous for crops?',
    'I think I have the same issue at my farm.',
    'How did you get rid of it?',
    'This looks like what we call "mbundu" in my village.',
    'The local agricultural office has a program to control these.',
    'I recommend using neem oil to control this pest.',
  ];
  
  Future<List<Report>> getReports({
    int offset = 0,
    int limit = 10,
    String filter = 'all',
    String sort = 'recent',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock reports
    final reports = List.generate(
      limit,
      (index) => _generateMockReport(offset + index),
    );
    
    // Apply filters
    var filteredReports = [...reports];
    if (filter == 'verified') {
      filteredReports = filteredReports.where((r) => r.isVerified).toList();
    } else if (filter == 'high_risk') {
      filteredReports = filteredReports.where((r) => r.riskLevel == RiskLevel.high).toList();
    } else if (filter == 'nearby') {
      filteredReports = filteredReports.where((r) => r.location == 'Harare, Zimbabwe').toList();
    } else if (filter == 'my_reports') {
      filteredReports = filteredReports.where((r) => r.userId == 'current_user').toList();
    }
    
    // Apply sorting
    if (sort == 'popular') {
      filteredReports.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    } else if (sort == 'comments') {
      filteredReports.sort((a, b) => b.commentCount.compareTo(a.commentCount));
    } else {
      // Default: recent
      filteredReports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    
    // Simulate pagination end
    if (offset > 30) {
      return [];
    }
    
    return filteredReports;
  }
  
  Future<List<Comment>> getComments(String reportId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock comments
    final random = Random();
    final commentCount = random.nextInt(5) + 1;
    
    return List.generate(
      commentCount,
      (index) => _generateMockComment(reportId, index),
    );
  }
  
  Future<Comment> addComment(String reportId, String text) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate a new comment
    return Comment(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      reportId: reportId,
      userId: 'current_user',
      userName: 'You',
      text: text,
      timestamp: DateTime.now(),
      likeCount: 0,
      isLiked: false,
      isExpert: false,
    );
  }
  
  Future<void> likeReport(String reportId, bool like) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would update the backend
  }
  
  Future<Report> createReport({
    required File imageFile,
    required String pestName,
    String? pestScientificName,
    required RiskLevel riskLevel,
    String? description,
    String? location,
  }) async {
    // Simulate network delay and image upload
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would upload the image and create a report
    return Report(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'You',
      pestName: pestName,
      pestScientificName: pestScientificName,
      imageUrl: _pestImages[Random().nextInt(_pestImages.length)],
      timestamp: DateTime.now(),
      location: location,
      description: description,
      riskLevel: riskLevel,
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
      isVerified: false,
    );
  }
  
  Report _generateMockReport(int index) {
    final random = Random();
    final isVerified = random.nextBool();
    const riskLevels = RiskLevel.values;
    
    return Report(
      id: 'report_$index',
      userId: 'user_$index',
      userName: _userNames[random.nextInt(_userNames.length)],
      userAvatarUrl: null,
      pestName: index % 3 == 0 ? 'Tsetse Fly' : (index % 3 == 1 ? 'Fall Armyworm' : 'Anopheles Mosquito'),
      pestScientificName: index % 3 == 0 ? 'Glossina morsitans' : (index % 3 == 1 ? 'Spodoptera frugiperda' : 'Anopheles gambiae'),
      imageUrl: _pestImages[random.nextInt(_pestImages.length)],
      timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(72))),
      location: _locations[random.nextInt(_locations.length)],
      description: index % 2 == 0 ? 'Found this pest in my maize field. It seems to be causing damage to the crops.' : null,
      riskLevel: riskLevels[random.nextInt(riskLevels.length)],
      likeCount: random.nextInt(50),
      commentCount: random.nextInt(10),
      isLiked: random.nextBool(),
      isVerified: isVerified,
    );
  }
  
  Comment _generateMockComment(String reportId, int index) {
    final random = Random();
    
    return Comment(
      id: 'comment_${reportId}_$index',
      reportId: reportId,
      userId: 'user_comment_$index',
      userName: _userNames[random.nextInt(_userNames.length)],
      userAvatarUrl: null,
      text: _commentTexts[random.nextInt(_commentTexts.length)],
      timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      likeCount: random.nextInt(10),
      isLiked: random.nextBool(),
      isExpert: index == 0 ? true : random.nextDouble() < 0.2,
    );
  }
}

