import { useState, useRef } from 'react';
import {
  ThumbsUp,
  ThumbsDown,
  MessageCircle,
  Share2,
  MapPin,
  Volume2,
  VolumeX,
  Play,
  Pause,
  Globe,
  Flag,
} from 'lucide-react';
import { TranslationModal } from './TranslationModal';

export interface Post {
  id: string;
  type: 'text' | 'video' | 'audio';
  user: {
    username: string;
    avatar: string;
  };
  location: string;
  timePosted: string;
  content: {
    text?: string;
    videoUrl?: string;
    audioUrl?: string;
  };
  engagement: {
    likes: number;
    dislikes: number;
    comments: number;
    shares: number;
  };
  language: string;
  isHighRisk?: boolean;
}

interface PostCardProps {
  post: Post;
}

export function PostCard({ post }: PostCardProps) {
  const [isTranslationModalOpen, setIsTranslationModalOpen] = useState(false);
  const [currentLanguage, setCurrentLanguage] = useState(post.language);
  const [isVideoMuted, setIsVideoMuted] = useState(true);
  const [isVideoPlaying, setIsVideoPlaying] = useState(false);
  const [isAudioPlaying, setIsAudioPlaying] = useState(false);
  const [liked, setLiked] = useState(false);
  const [disliked, setDisliked] = useState(false);
  
  const videoRef = useRef<HTMLVideoElement>(null);

  const handleVideoClick = () => {
    if (videoRef.current) {
      if (isVideoPlaying) {
        videoRef.current.pause();
      } else {
        videoRef.current.play();
      }
      setIsVideoPlaying(!isVideoPlaying);
    }
  };

  const toggleMute = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (videoRef.current) {
      videoRef.current.muted = !isVideoMuted;
      setIsVideoMuted(!isVideoMuted);
    }
  };

  const handleLike = () => {
    setLiked(!liked);
    if (disliked) setDisliked(false);
  };

  const handleDislike = () => {
    setDisliked(!disliked);
    if (liked) setLiked(false);
  };

  return (
    <div className={`bg-white border-b-8 border-[var(--grey-soft)] ${post.isHighRisk ? 'border-l-4 border-l-[var(--alert-orange)]' : ''}`}>
      {/* Post Header */}
      <div className="flex items-center justify-between p-4">
        <div className="flex items-center gap-3">
          <div className="w-11 h-11 rounded-full bg-gradient-to-br from-gray-300 to-gray-400 flex items-center justify-center text-xl">
            <span>{post.user.avatar}</span>
          </div>
          <div>
            <p className="font-medium text-gray-900">{post.user.username}</p>
            <div className="flex items-center gap-2 text-xs text-gray-500">
              <MapPin className="w-3 h-3" />
              <span>{post.location}</span>
              <span>•</span>
              <span>{post.timePosted}</span>
            </div>
          </div>
        </div>
        <button className="p-2 hover:bg-gray-100 rounded-full">
          <Flag className="w-5 h-5 text-gray-600" />
        </button>
      </div>

      {/* Post Content */}
      <div className="px-4 pb-3">
        {post.type === 'text' && post.content.text && (
          <p className="text-base leading-relaxed text-gray-900">{post.content.text}</p>
        )}

        {post.type === 'video' && post.content.videoUrl && (
          <div className="relative -mx-4 mb-3">
            <video
              ref={videoRef}
              src={post.content.videoUrl}
              className="w-full aspect-[9/16] max-h-[500px] object-cover bg-black cursor-pointer"
              loop
              muted={isVideoMuted}
              playsInline
              onClick={handleVideoClick}
            />
            <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
              {!isVideoPlaying && (
                <div className="w-16 h-16 rounded-full bg-white/90 flex items-center justify-center">
                  <Play className="w-8 h-8 text-[var(--green-primary)] ml-1" />
                </div>
              )}
            </div>
            <button
              onClick={toggleMute}
              className="absolute bottom-4 right-4 w-10 h-10 rounded-full bg-black/50 flex items-center justify-center pointer-events-auto"
            >
              {isVideoMuted ? (
                <VolumeX className="w-5 h-5 text-white" />
              ) : (
                <Volume2 className="w-5 h-5 text-white" />
              )}
            </button>
          </div>
        )}

        {post.type === 'audio' && (
          <div className="bg-gradient-to-r from-[var(--green-primary)]/10 to-[var(--green-primary)]/5 rounded-2xl p-4 mb-3">
            <div className="flex items-center gap-4">
              <button
                onClick={() => setIsAudioPlaying(!isAudioPlaying)}
                className="w-12 h-12 rounded-full bg-[var(--green-primary)] flex items-center justify-center flex-shrink-0"
              >
                {isAudioPlaying ? (
                  <Pause className="w-6 h-6 text-white" />
                ) : (
                  <Play className="w-6 h-6 text-white ml-0.5" />
                )}
              </button>
              <div className="flex-1">
                {/* Audio waveform visualization */}
                <div className="flex items-center gap-1 h-12">
                  {[...Array(30)].map((_, i) => (
                    <div
                      key={i}
                      className="flex-1 bg-[var(--green-primary)] rounded-full opacity-60"
                      style={{
                        height: `${Math.random() * 100}%`,
                        minHeight: '20%',
                      }}
                    />
                  ))}
                </div>
              </div>
            </div>
            <p className="text-sm text-gray-600 mt-2">Audio Message • 0:45</p>
          </div>
        )}

        {post.content.text && post.type !== 'text' && (
          <p className="text-base leading-relaxed text-gray-900 mt-3">{post.content.text}</p>
        )}
      </div>

      {/* Translation Controls */}
      <div className="px-4 pb-3">
        <button
          onClick={() => setIsTranslationModalOpen(true)}
          className="flex items-center gap-2 text-sm text-[var(--green-primary)] hover:underline"
        >
          <Globe className="w-4 h-4" />
          <span>Translate</span>
          {currentLanguage !== post.language && (
            <span className="text-xs bg-[var(--green-primary)]/10 px-2 py-0.5 rounded-full">
              {currentLanguage.toUpperCase()}
            </span>
          )}
        </button>
      </div>

      {/* Engagement Bar */}
      <div className="px-4 py-3 border-t border-[var(--grey-soft)]">
        <div className="flex items-center justify-between">
          <button
            onClick={handleLike}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              liked ? 'bg-[var(--green-primary)]/10 text-[var(--green-primary)]' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <ThumbsUp className={`w-5 h-5 ${liked ? 'fill-[var(--green-primary)]' : ''}`} />
            <span className="text-sm font-medium">{post.engagement.likes + (liked ? 1 : 0)}</span>
          </button>

          <button
            onClick={handleDislike}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              disliked ? 'bg-red-50 text-red-600' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <ThumbsDown className={`w-5 h-5 ${disliked ? 'fill-red-600' : ''}`} />
            <span className="text-sm font-medium">{post.engagement.dislikes + (disliked ? 1 : 0)}</span>
          </button>

          <button className="flex items-center gap-2 px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-100 transition-colors">
            <MessageCircle className="w-5 h-5" />
            <span className="text-sm font-medium">{post.engagement.comments}</span>
          </button>

          <button className="flex items-center gap-2 px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-100 transition-colors">
            <Share2 className="w-5 h-5" />
            <span className="text-sm font-medium">{post.engagement.shares}</span>
          </button>
        </div>
      </div>

      {/* High Risk Warning */}
      {post.isHighRisk && (
        <div className="px-4 py-3 bg-[var(--alert-orange)]/10 border-t border-[var(--alert-orange)]/20">
          <p className="text-sm text-[var(--alert-orange)] font-medium">
            ⚠️ This post has been flagged for verification
          </p>
        </div>
      )}

      {/* Translation Modal */}
      <TranslationModal
        isOpen={isTranslationModalOpen}
        onClose={() => setIsTranslationModalOpen(false)}
        currentLanguage={currentLanguage}
        onSelectLanguage={setCurrentLanguage}
      />
    </div>
  );
}
