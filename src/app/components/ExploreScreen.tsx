import { useState } from 'react';
import { Map, List, Filter, TrendingUp, MapPin, AlertTriangle } from 'lucide-react';
import { PostCard, Post } from './PostCard';

type ViewMode = 'map' | 'list';
type FilterMode = 'nearby' | 'state' | 'nationwide';

const mockPosts: Post[] = [
  {
    id: 'e1',
    type: 'text',
    user: {
      username: 'Emergency Alert',
      avatar: '🚨',
    },
    location: 'Victoria Island, Lagos',
    timePosted: '15min ago',
    content: {
      text: 'URGENT: Fire outbreak at commercial building. Emergency services on site. Avoid Akin Adesola Street.',
    },
    engagement: {
      likes: 1234,
      dislikes: 23,
      comments: 456,
      shares: 789,
    },
    language: 'en',
    isHighRisk: true,
  },
  {
    id: 'e2',
    type: 'video',
    user: {
      username: 'Adeola Bakare',
      avatar: '👩🏿',
    },
    location: 'Wuse 2, Abuja',
    timePosted: '1h ago',
    content: {
      text: 'Peaceful protest ongoing at Unity Fountain. Citizens demanding better infrastructure.',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    },
    engagement: {
      likes: 2345,
      dislikes: 178,
      comments: 567,
      shares: 890,
    },
    language: 'en',
  },
  {
    id: 'e3',
    type: 'text',
    user: {
      username: 'Emeka Nnaji',
      avatar: '👨🏿',
    },
    location: 'New Haven, Enugu',
    timePosted: '3h ago',
    content: {
      text: 'Water shortage in our community for 3 days now. Residents are struggling. We need government intervention.',
    },
    engagement: {
      likes: 678,
      dislikes: 45,
      comments: 123,
      shares: 234,
    },
    language: 'ig',
    isHighRisk: true,
  },
];

export function ExploreScreen() {
  const [viewMode, setViewMode] = useState<ViewMode>('list');
  const [filterMode, setFilterMode] = useState<FilterMode>('nearby');

  return (
    <div className="min-h-screen bg-[var(--grey-soft)]">
      {/* Header */}
      <div className="bg-white border-b border-[var(--grey-soft)] sticky top-0 z-10">
        <div className="px-4 py-4">
          <h1 className="text-xl text-[var(--green-dark)]">Explore</h1>
        </div>

        {/* View Toggle */}
        <div className="px-4 pb-3 flex gap-2">
          <button
            onClick={() => setViewMode('map')}
            className={`flex-1 py-2 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors ${
              viewMode === 'map'
                ? 'bg-[var(--green-primary)] text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            <Map className="w-4 h-4" />
            <span>Map View</span>
          </button>
          <button
            onClick={() => setViewMode('list')}
            className={`flex-1 py-2 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors ${
              viewMode === 'list'
                ? 'bg-[var(--green-primary)] text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            <List className="w-4 h-4" />
            <span>List View</span>
          </button>
        </div>

        {/* Filters */}
        <div className="px-4 pb-3 flex gap-2 overflow-x-auto">
          <button
            onClick={() => setFilterMode('nearby')}
            className={`px-4 py-2 rounded-full flex items-center gap-2 whitespace-nowrap transition-colors ${
              filterMode === 'nearby'
                ? 'bg-[var(--green-primary)] text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            <MapPin className="w-4 h-4" />
            <span>Nearby</span>
          </button>
          <button
            onClick={() => setFilterMode('state')}
            className={`px-4 py-2 rounded-full whitespace-nowrap transition-colors ${
              filterMode === 'state'
                ? 'bg-[var(--green-primary)] text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            State
          </button>
          <button
            onClick={() => setFilterMode('nationwide')}
            className={`px-4 py-2 rounded-full whitespace-nowrap transition-colors ${
              filterMode === 'nationwide'
                ? 'bg-[var(--green-primary)] text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            Nationwide
          </button>
        </div>
      </div>

      {/* Content */}
      {viewMode === 'map' ? (
        <div className="p-4">
          {/* Map View */}
          <div className="bg-white rounded-2xl overflow-hidden shadow-sm">
            <div className="relative h-[500px] bg-gradient-to-br from-green-50 to-blue-50">
              {/* Simplified map illustration */}
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="text-center">
                  <Map className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">Interactive map showing nearby reports</p>
                  <p className="text-sm text-gray-400 mt-2">
                    {filterMode === 'nearby' && 'Showing reports within 5km'}
                    {filterMode === 'state' && 'Showing reports in Lagos State'}
                    {filterMode === 'nationwide' && 'Showing reports nationwide'}
                  </p>
                </div>
              </div>

              {/* Map pins */}
              <div className="absolute top-1/4 left-1/3 w-8 h-8 bg-[var(--alert-orange)] rounded-full flex items-center justify-center shadow-lg cursor-pointer transform hover:scale-110 transition-transform">
                <AlertTriangle className="w-5 h-5 text-white" />
              </div>
              <div className="absolute top-1/2 right-1/4 w-8 h-8 bg-[var(--green-primary)] rounded-full flex items-center justify-center shadow-lg cursor-pointer transform hover:scale-110 transition-transform">
                <MapPin className="w-5 h-5 text-white" />
              </div>
              <div className="absolute bottom-1/3 left-1/2 w-8 h-8 bg-[var(--alert-orange)] rounded-full flex items-center justify-center shadow-lg cursor-pointer transform hover:scale-110 transition-transform">
                <AlertTriangle className="w-5 h-5 text-white" />
              </div>
              <div className="absolute top-2/3 right-1/3 w-8 h-8 bg-[var(--green-primary)] rounded-full flex items-center justify-center shadow-lg cursor-pointer transform hover:scale-110 transition-transform">
                <MapPin className="w-5 h-5 text-white" />
              </div>
            </div>

            {/* Map legend */}
            <div className="p-4 border-t border-gray-200">
              <div className="flex items-center justify-center gap-6">
                <div className="flex items-center gap-2">
                  <div className="w-4 h-4 bg-[var(--green-primary)] rounded-full"></div>
                  <span className="text-sm text-gray-600">Normal Reports</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-4 h-4 bg-[var(--alert-orange)] rounded-full"></div>
                  <span className="text-sm text-gray-600">Urgent/High Risk</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div>
          {/* Trending Section */}
          <div className="bg-white border-b-2 border-[var(--grey-soft)] p-4">
            <div className="flex items-center gap-2 mb-3">
              <TrendingUp className="w-5 h-5 text-[var(--green-primary)]" />
              <h2 className="font-medium text-gray-900">Trending Now</h2>
            </div>
            <div className="space-y-2">
              <div className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                <div className="w-2 h-2 bg-[var(--alert-orange)] rounded-full mt-2"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">Fire outbreak in Victoria Island</p>
                  <p className="text-xs text-gray-500">1.2K reports • Lagos</p>
                </div>
              </div>
              <div className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                <div className="w-2 h-2 bg-[var(--green-primary)] rounded-full mt-2"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">Community clean-up initiative</p>
                  <p className="text-xs text-gray-500">892 reports • Nationwide</p>
                </div>
              </div>
            </div>
          </div>

          {/* Posts List */}
          <div className="pb-4">
            {mockPosts.map((post) => (
              <PostCard key={post.id} post={post} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}