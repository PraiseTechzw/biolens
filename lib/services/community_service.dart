import '../models/post.dart';

class CommunityService {
  // Simulate API calls with mock data
  Future<List<Post>> getTrendingPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return [
      Post(
        id: '1',
        userName: 'Jane Smith',
        userAvatar: '/placeholder.svg?height=50&width=50',
        timeAgo: '2 hours ago',
        content: 'I found this interesting fly in my garden today. Can anyone help identify it?',
        imageUrl: '/placeholder.svg?height=400&width=400',
        comments: [
          Comment(
            id: '1',
            userName: 'John Doe',
            userAvatar: '/placeholder.svg?height=50&width=50',
            text: 'Looks like a hover fly to me. They\'re great pollinators!',
            timeAgo: '1 hour ago',
          ),
          Comment(
            id: '2',
            userName: 'Emily Johnson',
            userAvatar: '/placeholder.svg?height=50&width=50',
            text: 'I agree with John. Specifically, it looks like Syrphus ribesii.',
            timeAgo: '30 minutes ago',
          ),
        ],
        likes: 15,
      ),
      Post(
        id: '2',
        userName: 'Michael Brown',
        userAvatar: '/placeholder.svg?height=50&width=50',
        timeAgo: '1 day ago',
        content: 'Just completed my research on fruit fly genetics. Fascinating how these tiny creatures contribute to our understanding of human genetics!',
        comments: [
          Comment(
            id: '3',
            userName: 'Sarah Wilson',
            userAvatar: '/placeholder.svg?height=50&width=50',
            text: 'Would love to hear more about your research findings!',
            timeAgo: '20 hours ago',
          ),
        ],
        likes: 32,
      ),
    ];
  }
  
  Future<List<Post>> getRecentPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return [
      Post(
        id: '3',
        userName: 'David Wilson',
        userAvatar: '/placeholder.svg?height=50&width=50',
        timeAgo: '10 minutes ago',
        content: 'Has anyone used BioLens to identify this fly? The app suggested it\'s a Blow Fly but I\'m not convinced.',
        imageUrl: '/placeholder.svg?height=400&width=400',
        comments: [],
        likes: 3,
      ),
      Post(
        id: '4',
        userName: 'Lisa Johnson',
        userAvatar: '/placeholder.svg?height=50&width=50',
        timeAgo: '1 hour ago',
        content: 'I\'m new to entomology and trying to learn more about flies. Any recommended resources for beginners?',
        comments: [
          Comment(
            id: '4',
            userName: 'Robert Davis',
            userAvatar: '/placeholder.svg?height=50&width=50',
            text: 'Check out "The Fly Book" by Dr. Smith. It\'s a great introduction!',
            timeAgo: '45 minutes ago',
          ),
        ],
        likes: 8,
      ),
    ];
  }
}

