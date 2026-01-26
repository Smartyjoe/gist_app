import { StatusStories } from './StatusStories';
import { PostCard, Post } from './PostCard';

// Mock data for posts
const mockPosts: Post[] = [
  {
    id: '1',
    type: 'text',
    user: {
      username: 'Adewale Ogunleye',
      avatar: '👨🏿',
    },
    location: 'Ikeja, Lagos',
    timePosted: '2h ago',
    content: {
      text: 'Road construction on Allen Avenue causing heavy traffic. Alternative routes recommended via Obafemi Awolowo Way.',
    },
    engagement: {
      likes: 234,
      dislikes: 12,
      comments: 45,
      shares: 18,
    },
    language: 'en',
  },
  {
    id: '2',
    type: 'video',
    user: {
      username: 'Ngozi Adekunle',
      avatar: '👩🏿',
    },
    location: 'Garki, Abuja',
    timePosted: '4h ago',
    content: {
      text: 'Community clean-up initiative at Central Park. Join us this Saturday!',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    },
    engagement: {
      likes: 567,
      dislikes: 8,
      comments: 89,
      shares: 156,
    },
    language: 'en',
  },
  {
    id: '3',
    type: 'audio',
    user: {
      username: 'Ibrahim Musa',
      avatar: '👨🏿‍🦱',
    },
    location: 'Sabon Gari, Kano',
    timePosted: '6h ago',
    content: {
      text: 'Important announcement from the community leader regarding the upcoming town hall meeting.',
    },
    engagement: {
      likes: 189,
      dislikes: 5,
      comments: 23,
      shares: 34,
    },
    language: 'ha',
  },
  {
    id: '4',
    type: 'text',
    user: {
      username: 'Fatima Yusuf',
      avatar: '👩🏿‍🦱',
    },
    location: 'Asokoro, Abuja',
    timePosted: '8h ago',
    content: {
      text: 'Power outage in our area since morning. NEPA officials are working on it. Expected restoration by evening.',
    },
    engagement: {
      likes: 412,
      dislikes: 156,
      comments: 78,
      shares: 45,
    },
    language: 'en',
    isHighRisk: true,
  },
  {
    id: '5',
    type: 'video',
    user: {
      username: 'Chidi Okafor',
      avatar: '👨🏿',
    },
    location: 'Enugu North, Enugu',
    timePosted: '10h ago',
    content: {
      text: 'New market opening ceremony - fresh produce and local goods available at affordable prices!',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
    engagement: {
      likes: 892,
      dislikes: 15,
      comments: 134,
      shares: 267,
    },
    language: 'ig',
  },
];

export function HomeFeed() {
  return (
    <div className="min-h-screen bg-[var(--grey-soft)]">
      {/* Header */}
      <div className="bg-white border-b border-[var(--grey-soft)] px-4 py-4 sticky top-0 z-10">
        <h1 className="text-xl text-[var(--green-dark)]">Community Reports</h1>
      </div>

      {/* Status Stories */}
      <StatusStories />

      {/* Posts Feed */}
      <div className="pb-4">
        {mockPosts.map((post) => (
          <PostCard key={post.id} post={post} />
        ))}
      </div>
    </div>
  );
}