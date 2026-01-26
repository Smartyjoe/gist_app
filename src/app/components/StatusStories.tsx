import { Plus } from 'lucide-react';

interface Story {
  id: string;
  username: string;
  avatar: string;
  hasViewed: boolean;
}

const stories: Story[] = [
  { id: '1', username: 'Adewale', avatar: '👨🏿', hasViewed: false },
  { id: '2', username: 'Ngozi', avatar: '👩🏿', hasViewed: false },
  { id: '3', username: 'Ibrahim', avatar: '👨🏿‍🦱', hasViewed: true },
  { id: '4', username: 'Fatima', avatar: '👩🏿‍🦱', hasViewed: false },
  { id: '5', username: 'Chidi', avatar: '👨🏿', hasViewed: true },
];

export function StatusStories() {
  return (
    <div className="bg-white border-b border-[var(--grey-soft)] px-4 py-3">
      <div className="flex gap-4 overflow-x-auto scrollbar-hide">
        {/* Add your story */}
        <button className="flex flex-col items-center gap-2 flex-shrink-0">
          <div className="w-16 h-16 rounded-full bg-gradient-to-br from-gray-200 to-gray-300 flex items-center justify-center text-2xl relative">
            <span>👤</span>
            <div className="absolute bottom-0 right-0 w-5 h-5 bg-[var(--green-primary)] rounded-full flex items-center justify-center border-2 border-white">
              <Plus className="w-3 h-3 text-white" />
            </div>
          </div>
          <span className="text-xs text-gray-700">Your Status</span>
        </button>

        {/* Story items */}
        {stories.map((story) => (
          <button key={story.id} className="flex flex-col items-center gap-2 flex-shrink-0">
            <div
              className={`w-16 h-16 rounded-full flex items-center justify-center text-2xl ${
                story.hasViewed
                  ? 'bg-gradient-to-br from-gray-300 to-gray-400'
                  : 'bg-gradient-to-br from-[var(--green-primary)] to-[var(--green-dark)]'
              } p-[3px]`}
            >
              <div className="w-full h-full rounded-full bg-white flex items-center justify-center">
                <span>{story.avatar}</span>
              </div>
            </div>
            <span className="text-xs text-gray-700 max-w-[64px] truncate">{story.username}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
