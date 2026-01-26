import { useState } from 'react';
import {
  X,
  FileText,
  Video,
  Mic,
  Clock,
  ChevronRight,
  MapPin,
  Upload,
  Check,
} from 'lucide-react';

interface CreatePostScreenProps {
  onClose: () => void;
}

type PostType = 'text' | 'video' | 'audio' | 'status' | null;
type Step = 'type' | 'content' | 'language' | 'location' | 'confirm';

const languages = [
  { code: 'en', name: 'English' },
  { code: 'yo', name: 'Yoruba' },
  { code: 'ha', name: 'Hausa' },
  { code: 'ig', name: 'Igbo' },
];

export function CreatePostScreen({ onClose }: CreatePostScreenProps) {
  const [currentStep, setCurrentStep] = useState<Step>('type');
  const [postType, setPostType] = useState<PostType>(null);
  const [content, setContent] = useState('');
  const [selectedLanguage, setSelectedLanguage] = useState('en');
  const [location, setLocation] = useState('Ikeja, Lagos');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSelectType = (type: PostType) => {
    setPostType(type);
    setCurrentStep('content');
  };

  const handleContentNext = () => {
    if (content.trim()) {
      setCurrentStep('language');
    }
  };

  const handleLanguageNext = () => {
    setCurrentStep('location');
  };

  const handleLocationNext = () => {
    setCurrentStep('confirm');
  };

  const handleSubmit = () => {
    setIsSubmitting(true);
    // Simulate API call
    setTimeout(() => {
      setIsSubmitting(false);
      onClose();
    }, 1500);
  };

  const renderStep = () => {
    switch (currentStep) {
      case 'type':
        return (
          <div className="flex-1 p-6 flex flex-col justify-center">
            <h2 className="text-2xl mb-2 text-center">Choose Post Type</h2>
            <p className="text-gray-500 text-center mb-8">What would you like to share?</p>

            <div className="space-y-4">
              <button
                onClick={() => handleSelectType('text')}
                className="w-full p-6 bg-white border-2 border-gray-200 rounded-2xl hover:border-[var(--green-primary)] hover:bg-green-50 transition-all flex items-center gap-4 group"
              >
                <div className="w-14 h-14 rounded-full bg-[var(--green-primary)]/10 flex items-center justify-center group-hover:bg-[var(--green-primary)] transition-colors">
                  <FileText className="w-7 h-7 text-[var(--green-primary)] group-hover:text-white" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-medium text-gray-900">Text Post</h3>
                  <p className="text-sm text-gray-500">Share a written report</p>
                </div>
                <ChevronRight className="w-6 h-6 text-gray-400 group-hover:text-[var(--green-primary)]" />
              </button>

              <button
                onClick={() => handleSelectType('video')}
                className="w-full p-6 bg-white border-2 border-gray-200 rounded-2xl hover:border-[var(--green-primary)] hover:bg-green-50 transition-all flex items-center gap-4 group"
              >
                <div className="w-14 h-14 rounded-full bg-[var(--green-primary)]/10 flex items-center justify-center group-hover:bg-[var(--green-primary)] transition-colors">
                  <Video className="w-7 h-7 text-[var(--green-primary)] group-hover:text-white" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-medium text-gray-900">Video Post</h3>
                  <p className="text-sm text-gray-500">Upload or record video</p>
                </div>
                <ChevronRight className="w-6 h-6 text-gray-400 group-hover:text-[var(--green-primary)]" />
              </button>

              <button
                onClick={() => handleSelectType('audio')}
                className="w-full p-6 bg-white border-2 border-gray-200 rounded-2xl hover:border-[var(--green-primary)] hover:bg-green-50 transition-all flex items-center gap-4 group"
              >
                <div className="w-14 h-14 rounded-full bg-[var(--green-primary)]/10 flex items-center justify-center group-hover:bg-[var(--green-primary)] transition-colors">
                  <Mic className="w-7 h-7 text-[var(--green-primary)] group-hover:text-white" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-medium text-gray-900">Voice Message</h3>
                  <p className="text-sm text-gray-500">Record audio message</p>
                </div>
                <ChevronRight className="w-6 h-6 text-gray-400 group-hover:text-[var(--green-primary)]" />
              </button>

              <button
                onClick={() => handleSelectType('status')}
                className="w-full p-6 bg-white border-2 border-gray-200 rounded-2xl hover:border-[var(--green-primary)] hover:bg-green-50 transition-all flex items-center gap-4 group"
              >
                <div className="w-14 h-14 rounded-full bg-[var(--green-primary)]/10 flex items-center justify-center group-hover:bg-[var(--green-primary)] transition-colors">
                  <Clock className="w-7 h-7 text-[var(--green-primary)] group-hover:text-white" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-medium text-gray-900">Status (24 hours)</h3>
                  <p className="text-sm text-gray-500">Quick update that expires</p>
                </div>
                <ChevronRight className="w-6 h-6 text-gray-400 group-hover:text-[var(--green-primary)]" />
              </button>
            </div>
          </div>
        );

      case 'content':
        return (
          <div className="flex-1 p-6 flex flex-col">
            <h2 className="text-2xl mb-2">
              {postType === 'text' && 'Write Your Report'}
              {postType === 'video' && 'Add Video'}
              {postType === 'audio' && 'Record Voice Message'}
              {postType === 'status' && 'Create Status'}
            </h2>
            <p className="text-gray-500 mb-6">Share what's happening in your community</p>

            {(postType === 'text' || postType === 'status') && (
              <textarea
                value={content}
                onChange={(e) => setContent(e.target.value)}
                placeholder="Describe the situation, location details, and any important information..."
                className="flex-1 p-4 border-2 border-gray-200 rounded-2xl resize-none focus:outline-none focus:border-[var(--green-primary)] text-base"
                autoFocus
              />
            )}

            {postType === 'video' && (
              <div className="flex-1 flex flex-col items-center justify-center border-2 border-dashed border-gray-300 rounded-2xl">
                <Upload className="w-16 h-16 text-gray-400 mb-4" />
                <p className="text-gray-600 mb-2">Upload Video</p>
                <p className="text-sm text-gray-400 mb-6">or record using your camera</p>
                <div className="flex gap-3">
                  <button className="px-6 py-3 bg-[var(--green-primary)] text-white rounded-xl">
                    Upload File
                  </button>
                  <button className="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl">
                    Record Now
                  </button>
                </div>
                <textarea
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  placeholder="Add description (optional)"
                  className="w-full mt-6 p-4 border-2 border-gray-200 rounded-2xl resize-none focus:outline-none focus:border-[var(--green-primary)] h-24"
                />
              </div>
            )}

            {postType === 'audio' && (
              <div className="flex-1 flex flex-col items-center justify-center">
                <div className="w-48 h-48 rounded-full bg-gradient-to-br from-[var(--green-primary)] to-[var(--green-dark)] flex items-center justify-center mb-8 shadow-2xl">
                  <Mic className="w-24 h-24 text-white" />
                </div>
                <p className="text-gray-600 mb-2">Tap to start recording</p>
                <p className="text-sm text-gray-400 mb-8">Clear audio helps everyone understand</p>
                <button className="w-20 h-20 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center shadow-lg">
                  <div className="w-8 h-8 rounded-full bg-white"></div>
                </button>
                <textarea
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  placeholder="Add description (optional)"
                  className="w-full mt-8 p-4 border-2 border-gray-200 rounded-2xl resize-none focus:outline-none focus:border-[var(--green-primary)] h-24"
                />
              </div>
            )}

            <button
              onClick={handleContentNext}
              disabled={!content.trim()}
              className="w-full mt-6 py-4 bg-[var(--green-primary)] text-white rounded-xl disabled:bg-gray-300 disabled:cursor-not-allowed"
            >
              Continue
            </button>
          </div>
        );

      case 'language':
        return (
          <div className="flex-1 p-6 flex flex-col">
            <h2 className="text-2xl mb-2">Select Language</h2>
            <p className="text-gray-500 mb-6">Choose the language of your post</p>

            <div className="flex-1 space-y-3">
              {languages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => setSelectedLanguage(lang.code)}
                  className={`w-full p-5 rounded-2xl border-2 transition-all flex items-center justify-between ${
                    selectedLanguage === lang.code
                      ? 'border-[var(--green-primary)] bg-green-50'
                      : 'border-gray-200 bg-white hover:border-gray-300'
                  }`}
                >
                  <span className="font-medium text-gray-900">{lang.name}</span>
                  {selectedLanguage === lang.code && (
                    <div className="w-6 h-6 rounded-full bg-[var(--green-primary)] flex items-center justify-center">
                      <Check className="w-4 h-4 text-white" />
                    </div>
                  )}
                </button>
              ))}
            </div>

            <button
              onClick={handleLanguageNext}
              className="w-full mt-6 py-4 bg-[var(--green-primary)] text-white rounded-xl"
            >
              Continue
            </button>
          </div>
        );

      case 'location':
        return (
          <div className="flex-1 p-6 flex flex-col">
            <h2 className="text-2xl mb-2">Set Location</h2>
            <p className="text-gray-500 mb-6">Help others know where this is happening</p>

            <div className="flex-1">
              <div className="mb-4">
                <label className="block text-sm text-gray-600 mb-2">Current Location</label>
                <div className="flex items-center gap-3 p-4 bg-green-50 border-2 border-[var(--green-primary)] rounded-2xl">
                  <MapPin className="w-5 h-5 text-[var(--green-primary)]" />
                  <span className="flex-1 text-gray-900">{location}</span>
                  <span className="text-xs text-[var(--green-primary)]">Auto-detected</span>
                </div>
              </div>

              <div>
                <label className="block text-sm text-gray-600 mb-2">Or enter manually</label>
                <input
                  type="text"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  placeholder="Enter location..."
                  className="w-full p-4 border-2 border-gray-200 rounded-2xl focus:outline-none focus:border-[var(--green-primary)]"
                />
              </div>

              <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-sm text-blue-800">
                  💡 Accurate location helps emergency services and community members respond faster
                </p>
              </div>
            </div>

            <button
              onClick={handleLocationNext}
              className="w-full mt-6 py-4 bg-[var(--green-primary)] text-white rounded-xl"
            >
              Continue
            </button>
          </div>
        );

      case 'confirm':
        return (
          <div className="flex-1 p-6 flex flex-col">
            <h2 className="text-2xl mb-2">Review Your Post</h2>
            <p className="text-gray-500 mb-6">Make sure everything looks good</p>

            <div className="flex-1 bg-white border-2 border-gray-200 rounded-2xl p-6 overflow-y-auto">
              <div className="space-y-4">
                <div>
                  <label className="text-sm text-gray-500">Type</label>
                  <p className="font-medium capitalize">{postType} Post</p>
                </div>

                <div>
                  <label className="text-sm text-gray-500">Content</label>
                  <p className="font-medium">{content}</p>
                </div>

                <div>
                  <label className="text-sm text-gray-500">Language</label>
                  <p className="font-medium">
                    {languages.find((l) => l.code === selectedLanguage)?.name}
                  </p>
                </div>

                <div>
                  <label className="text-sm text-gray-500">Location</label>
                  <div className="flex items-center gap-2">
                    <MapPin className="w-4 h-4 text-gray-600" />
                    <p className="font-medium">{location}</p>
                  </div>
                </div>
              </div>

              <div className="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-xl">
                <p className="text-sm text-yellow-800">
                  ⚠️ Please ensure your report is accurate and truthful. False reports may result in
                  account suspension.
                </p>
              </div>
            </div>

            <button
              onClick={handleSubmit}
              disabled={isSubmitting}
              className="w-full mt-6 py-4 bg-[var(--green-primary)] text-white rounded-xl disabled:bg-gray-300 flex items-center justify-center gap-2"
            >
              {isSubmitting ? (
                <>
                  <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  <span>Posting...</span>
                </>
              ) : (
                'Post Now'
              )}
            </button>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-[var(--grey-soft)] flex flex-col">
      {/* Header */}
      <div className="bg-white border-b border-[var(--grey-soft)] px-4 py-4 flex items-center justify-between sticky top-0 z-10">
        <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-full">
          <X className="w-6 h-6" />
        </button>
        <h1 className="text-lg">Create Post</h1>
        <div className="w-10"></div>
      </div>

      {/* Progress indicator */}
      {currentStep !== 'type' && (
        <div className="bg-white px-6 py-4 border-b border-[var(--grey-soft)]">
          <div className="flex items-center gap-2">
            <div
              className={`h-1 flex-1 rounded-full ${
                ['content', 'language', 'location', 'confirm'].includes(currentStep)
                  ? 'bg-[var(--green-primary)]'
                  : 'bg-gray-200'
              }`}
            ></div>
            <div
              className={`h-1 flex-1 rounded-full ${
                ['language', 'location', 'confirm'].includes(currentStep)
                  ? 'bg-[var(--green-primary)]'
                  : 'bg-gray-200'
              }`}
            ></div>
            <div
              className={`h-1 flex-1 rounded-full ${
                ['location', 'confirm'].includes(currentStep)
                  ? 'bg-[var(--green-primary)]'
                  : 'bg-gray-200'
              }`}
            ></div>
            <div
              className={`h-1 flex-1 rounded-full ${
                currentStep === 'confirm' ? 'bg-[var(--green-primary)]' : 'bg-gray-200'
              }`}
            ></div>
          </div>
        </div>
      )}

      {/* Main content */}
      {renderStep()}
    </div>
  );
}