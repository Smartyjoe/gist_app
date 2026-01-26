import { useState } from 'react';
import { Home, Compass, PlusCircle, Bell, User } from 'lucide-react';
import { HomeFeed } from '@/app/components/HomeFeed';
import { ExploreScreen } from '@/app/components/ExploreScreen';
import { CreatePostScreen } from '@/app/components/CreatePostScreen';
import { NotificationsScreen } from '@/app/components/NotificationsScreen';
import { ProfileScreen } from '@/app/components/ProfileScreen';

type Screen = 'home' | 'explore' | 'create' | 'notifications' | 'profile';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('home');

  const renderScreen = () => {
    switch (currentScreen) {
      case 'home':
        return <HomeFeed />;
      case 'explore':
        return <ExploreScreen />;
      case 'create':
        return <CreatePostScreen onClose={() => setCurrentScreen('home')} />;
      case 'notifications':
        return <NotificationsScreen />;
      case 'profile':
        return <ProfileScreen />;
      default:
        return <HomeFeed />;
    }
  };

  return (
    <div className="flex flex-col h-screen bg-background max-w-md mx-auto relative">
      {/* Main content area */}
      <div className="flex-1 overflow-y-auto pb-16">
        {renderScreen()}
      </div>

      {/* Bottom Navigation Bar */}
      <nav className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white border-t border-[var(--grey-soft)] z-50">
        <div className="flex items-center justify-around h-16 px-4">
          <button
            onClick={() => setCurrentScreen('home')}
            className="flex flex-col items-center justify-center gap-1 flex-1"
          >
            <Home
              className={`w-6 h-6 ${
                currentScreen === 'home'
                  ? 'text-[var(--green-primary)] fill-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            />
            <span
              className={`text-xs ${
                currentScreen === 'home' ? 'text-[var(--green-primary)]' : 'text-gray-500'
              }`}
            >
              Home
            </span>
          </button>

          <button
            onClick={() => setCurrentScreen('explore')}
            className="flex flex-col items-center justify-center gap-1 flex-1"
          >
            <Compass
              className={`w-6 h-6 ${
                currentScreen === 'explore'
                  ? 'text-[var(--green-primary)] fill-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            />
            <span
              className={`text-xs ${
                currentScreen === 'explore' ? 'text-[var(--green-primary)]' : 'text-gray-500'
              }`}
            >
              Explore
            </span>
          </button>

          <button
            onClick={() => setCurrentScreen('create')}
            className="flex flex-col items-center justify-center gap-1 flex-1"
          >
            <PlusCircle
              className={`w-7 h-7 ${
                currentScreen === 'create'
                  ? 'text-[var(--green-primary)] fill-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            />
            <span
              className={`text-xs ${
                currentScreen === 'create' ? 'text-[var(--green-primary)]' : 'text-gray-500'
              }`}
            >
              Create
            </span>
          </button>

          <button
            onClick={() => setCurrentScreen('notifications')}
            className="flex flex-col items-center justify-center gap-1 flex-1 relative"
          >
            <Bell
              className={`w-6 h-6 ${
                currentScreen === 'notifications'
                  ? 'text-[var(--green-primary)] fill-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            />
            {/* Notification badge */}
            <div className="absolute top-0 right-6 w-2 h-2 bg-[var(--alert-orange)] rounded-full"></div>
            <span
              className={`text-xs ${
                currentScreen === 'notifications'
                  ? 'text-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            >
              Alerts
            </span>
          </button>

          <button
            onClick={() => setCurrentScreen('profile')}
            className="flex flex-col items-center justify-center gap-1 flex-1"
          >
            <User
              className={`w-6 h-6 ${
                currentScreen === 'profile'
                  ? 'text-[var(--green-primary)] fill-[var(--green-primary)]'
                  : 'text-gray-500'
              }`}
            />
            <span
              className={`text-xs ${
                currentScreen === 'profile' ? 'text-[var(--green-primary)]' : 'text-gray-500'
              }`}
            >
              Profile
            </span>
          </button>
        </div>
      </nav>
    </div>
  );
}
