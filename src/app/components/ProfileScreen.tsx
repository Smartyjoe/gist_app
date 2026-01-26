import { useState } from 'react';
import {
  Settings,
  ChevronRight,
  Shield,
  Globe,
  Eye,
  Bell,
  Users,
  HelpCircle,
  LogOut,
  Award,
} from 'lucide-react';
import { SettingsModal } from './SettingsModal';

export function ProfileScreen() {
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<'posts' | 'status' | 'activity'>('posts');

  const stats = [
    { label: 'Posts', value: '24' },
    { label: 'Helpful', value: '1.2K' },
    { label: 'Credibility', value: '94%' },
  ];

  const menuItems = [
    {
      icon: <Settings className="w-5 h-5" />,
      label: 'Settings',
      onClick: () => setIsSettingsOpen(true),
    },
    { icon: <Globe className="w-5 h-5" />, label: 'Language & Translation', badge: 'English' },
    { icon: <Eye className="w-5 h-5" />, label: 'Accessibility Options' },
    { icon: <Bell className="w-5 h-5" />, label: 'Notification Preferences' },
    { icon: <Shield className="w-5 h-5" />, label: 'Privacy & Safety' },
    { icon: <Users className="w-5 h-5" />, label: 'Community Guidelines' },
    { icon: <HelpCircle className="w-5 h-5" />, label: 'Help & Support' },
  ];

  return (
    <div className="min-h-screen bg-[var(--grey-soft)]">
      {/* Header */}
      <div className="bg-white">
        {/* Profile Header */}
        <div className="px-4 pt-6 pb-4">
          <div className="flex items-center gap-4 mb-4">
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[var(--green-primary)] to-[var(--green-dark)] flex items-center justify-center text-3xl border-4 border-white shadow-lg">
              👤
            </div>
            <div className="flex-1">
              <h1 className="text-xl font-medium text-gray-900">Your Name</h1>
              <p className="text-sm text-gray-500">@username</p>
              <div className="flex items-center gap-2 mt-1">
                <Award className="w-4 h-4 text-[var(--green-primary)]" />
                <span className="text-xs text-[var(--green-primary)] font-medium">
                  Verified Community Member
                </span>
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2 mb-4">
            <span className="text-sm text-gray-600">📍 Ikeja, Lagos</span>
          </div>

          {/* Stats */}
          <div className="flex items-center justify-around py-4 border-t border-b border-gray-200">
            {stats.map((stat) => (
              <div key={stat.label} className="text-center">
                <p className="text-xl font-medium text-gray-900">{stat.value}</p>
                <p className="text-xs text-gray-500">{stat.label}</p>
              </div>
            ))}
          </div>

          {/* Tabs */}
          <div className="flex items-center gap-1 mt-4">
            <button
              onClick={() => setActiveTab('posts')}
              className={`flex-1 py-3 text-sm font-medium border-b-2 transition-colors ${
                activeTab === 'posts'
                  ? 'border-[var(--green-primary)] text-[var(--green-primary)]'
                  : 'border-transparent text-gray-500'
              }`}
            >
              Posts
            </button>
            <button
              onClick={() => setActiveTab('status')}
              className={`flex-1 py-3 text-sm font-medium border-b-2 transition-colors ${
                activeTab === 'status'
                  ? 'border-[var(--green-primary)] text-[var(--green-primary)]'
                  : 'border-transparent text-gray-500'
              }`}
            >
              Status
            </button>
            <button
              onClick={() => setActiveTab('activity')}
              className={`flex-1 py-3 text-sm font-medium border-b-2 transition-colors ${
                activeTab === 'activity'
                  ? 'border-[var(--green-primary)] text-[var(--green-primary)]'
                  : 'border-transparent text-gray-500'
              }`}
            >
              Activity
            </button>
          </div>
        </div>
      </div>

      {/* Content based on active tab */}
      <div className="mt-2 bg-white p-8">
        <div className="text-center text-gray-500">
          <p>Your {activeTab} will appear here</p>
        </div>
      </div>

      {/* Menu Items */}
      <div className="mt-2 bg-white">
        {menuItems.map((item, index) => (
          <button
            key={item.label}
            onClick={item.onClick}
            className={`w-full px-4 py-4 flex items-center gap-4 hover:bg-gray-50 transition-colors ${
              index !== menuItems.length - 1 ? 'border-b border-gray-100' : ''
            }`}
          >
            <div className="text-gray-600">{item.icon}</div>
            <span className="flex-1 text-left text-gray-900">{item.label}</span>
            {item.badge && (
              <span className="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                {item.badge}
              </span>
            )}
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        ))}

        {/* Logout */}
        <button className="w-full px-4 py-4 flex items-center gap-4 hover:bg-red-50 transition-colors text-red-600">
          <LogOut className="w-5 h-5" />
          <span className="flex-1 text-left">Log Out</span>
          <ChevronRight className="w-5 h-5 text-red-400" />
        </button>
      </div>

      {/* Version */}
      <div className="mt-4 p-4 text-center">
        <p className="text-xs text-gray-400">Community Reports v1.0.0</p>
        <p className="text-xs text-gray-400 mt-1">Built for the Nigerian people</p>
      </div>

      {/* Settings Modal */}
      <SettingsModal isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)} />
    </div>
  );
}