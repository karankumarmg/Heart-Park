class UserModel {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String location;
  final String profession;
  final List<String> interests;
  final List<String> photos;
  final double aiMatchScore;
  final bool isAnonymous;
  final bool isOnline;
  final String lastSeen;
  final String gender;
  final String lookingFor;

  const UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.location,
    required this.profession,
    required this.interests,
    required this.photos,
    this.aiMatchScore = 0.0,
    this.isAnonymous = false,
    this.isOnline = false,
    this.lastSeen = '',
    required this.gender,
    required this.lookingFor,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      profession: map['profession'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      aiMatchScore: (map['aiMatchScore'] ?? 0.0).toDouble(),
      isAnonymous: map['isAnonymous'] ?? false,
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] ?? '',
      gender: map['gender'] ?? '',
      lookingFor: map['lookingFor'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'age': age,
    'bio': bio,
    'location': location,
    'profession': profession,
    'interests': interests,
    'photos': photos,
    'aiMatchScore': aiMatchScore,
    'isAnonymous': isAnonymous,
    'isOnline': isOnline,
    'lastSeen': lastSeen,
    'gender': gender,
    'lookingFor': lookingFor,
  };
}

// ── Mock Data ──────────────────────────────────────────────────
const List<UserModel> mockProfiles = [
  UserModel(
    id: '1',
    name: 'Aanya',
    age: 24,
    bio: 'Graphic designer by day, stargazer by night ✨ Looking for someone to explore life with.',
    location: 'Chennai, TN',
    profession: 'UI/UX Designer',
    interests: ['Art', 'Travel', 'Music', 'Yoga', 'Coffee'],
    photos: [],
    aiMatchScore: 94,
    isOnline: true,
    gender: 'female',
    lookingFor: 'relationship',
  ),
  UserModel(
    id: '2',
    name: 'Kavya',
    age: 26,
    bio: 'Software engineer who loves hiking on weekends 🏔️ Chai > Coffee, fight me.',
    location: 'Bangalore, KA',
    profession: 'Software Engineer',
    interests: ['Tech', 'Hiking', 'Books', 'Cooking', 'Photography'],
    photos: [],
    aiMatchScore: 89,
    isOnline: false,
    gender: 'female',
    lookingFor: 'relationship',
  ),
  UserModel(
    id: '3',
    name: 'Ishaan',
    age: 27,
    bio: 'Musician & foodie. If you can recommend a good restaurant, we\'re already best friends 🎸',
    location: 'Mumbai, MH',
    profession: 'Musician',
    interests: ['Music', 'Food', 'Movies', 'Travel', 'Fitness'],
    photos: [],
    aiMatchScore: 82,
    isAnonymous: true,
    isOnline: true,
    gender: 'male',
    lookingFor: 'friendship',
  ),
  UserModel(
    id: '4',
    name: 'Priya',
    age: 25,
    bio: 'Doctor in training 🩺 Passionate about mental health. Let\'s grow together.',
    location: 'Madurai, TN',
    profession: 'Medical Student',
    interests: ['Health', 'Reading', 'Dance', 'Psychology', 'Travel'],
    photos: [],
    aiMatchScore: 91,
    isOnline: true,
    gender: 'female',
    lookingFor: 'relationship',
  ),
  UserModel(
    id: '5',
    name: 'Arjun',
    age: 28,
    bio: 'Architect who sees beauty in everything 🏛️ Sketching, coffee, and long walks.',
    location: 'Coimbatore, TN',
    profession: 'Architect',
    interests: ['Design', 'Art', 'Coffee', 'Travel', 'Photography'],
    photos: [],
    aiMatchScore: 86,
    isOnline: false,
    gender: 'male',
    lookingFor: 'relationship',
  ),
];

// ── Mock Chat Messages ─────────────────────────────────────────
class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime time;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    this.isRead = false,
  });
}

final Map<String, List<ChatMessage>> mockChats = {
  '1': [
    ChatMessage(id: 'm1', senderId: '1', text: 'Hey! I saw you also love travel ✈️', time: DateTime.now().subtract(const Duration(minutes: 10))),
    ChatMessage(id: 'm2', senderId: 'me', text: 'Yes!! Been to 8 countries so far 🌍', time: DateTime.now().subtract(const Duration(minutes: 8))),
    ChatMessage(id: 'm3', senderId: '1', text: 'Wow! Which was your favourite?', time: DateTime.now().subtract(const Duration(minutes: 7))),
    ChatMessage(id: 'm4', senderId: 'me', text: 'Japan was absolutely magical 🇯🇵', time: DateTime.now().subtract(const Duration(minutes: 5))),
    ChatMessage(id: 'm5', senderId: '1', text: 'Omg same! The food, the culture ❤️', time: DateTime.now().subtract(const Duration(minutes: 2))),
  ],
  '4': [
    ChatMessage(id: 'm1', senderId: '4', text: 'Are you free this weekend? ☕', time: DateTime.now().subtract(const Duration(hours: 2))),
    ChatMessage(id: 'm2', senderId: 'me', text: 'Yeah! What did you have in mind?', time: DateTime.now().subtract(const Duration(hours: 1))),
  ],
};