import { AlertTriangle, ThumbsUp, MessageCircle, Bell, Info } from 'lucide-react';

interface Notification {
  id: string;
  type: 'emergency' | 'engagement' | 'admin' | 'nearby';
  title: string;
  message: string;
  time: string;
  read: boolean;
}

const mockNotifications: Notification[] = [
  {
    id: '1',
    type: 'emergency',
    title: 'URGENT: Fire Outbreak',
    message: 'Major fire reported in Victoria Island. Emergency services responding.',
    time: '15min ago',
    read: false,
  },
  {
    id: '2',
    type: 'engagement',
    title: 'New likes on your post',
    message: 'Your post about road construction has received 124 likes',
    time: '1h ago',
    read: false,
  },
  {
    id: '3',
    type: 'nearby',
    title: 'New report nearby',
    message: 'Power outage reported 2km from your location',
    time: '2h ago',
    read: true,
  },
  {
    id: '4',
    type: 'engagement',
    title: 'New comment',
    message: 'Adewale commented on your post',
    time: '3h ago',
    read: true,
  },
  {
    id: '5',
    type: 'admin',
    title: 'Community Guidelines Update',
    message: 'New community guidelines have been published. Please review.',
    time: '1d ago',
    read: true,
  },
];

export function NotificationsScreen() {
  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'emergency':
        return <AlertTriangle className="w-5 h-5 text-white" />;
      case 'engagement':
        return <ThumbsUp className="w-5 h-5 text-white" />;
      case 'nearby':
        return <Bell className="w-5 h-5 text-white" />;
      case 'admin':
        return <Info className="w-5 h-5 text-white" />;
      default:
        return <Bell className="w-5 h-5 text-white" />;
    }
  };

  const getNotificationColor = (type: string) => {
    switch (type) {
      case 'emergency':
        return 'bg-[var(--alert-orange)]';
      case 'engagement':
        return 'bg-[var(--green-primary)]';
      case 'nearby':
        return 'bg-blue-500';
      case 'admin':
        return 'bg-gray-600';
      default:
        return 'bg-gray-500';
    }
  };

  const emergencyNotifications = mockNotifications.filter((n) => n.type === 'emergency');
  const otherNotifications = mockNotifications.filter((n) => n.type !== 'emergency');

  return (
    <div className="min-h-screen bg-[var(--grey-soft)]">
      {/* Header */}
      <div className="bg-white border-b border-[var(--grey-soft)] px-4 py-4 sticky top-0 z-10">
        <h1 className="text-xl text-[var(--green-dark)]">Notifications</h1>
      </div>

      {/* Emergency Notifications (Pinned) */}
      {emergencyNotifications.length > 0 && (
        <div className="bg-white border-b-2 border-[var(--grey-soft)] mb-2">
          <div className="px-4 py-3 bg-[var(--alert-orange)]/10 border-b border-[var(--alert-orange)]/20">
            <p className="text-sm font-medium text-[var(--alert-orange)]">
              🚨 Emergency Alerts
            </p>
          </div>
          {emergencyNotifications.map((notification) => (
            <div
              key={notification.id}
              className="px-4 py-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer flex gap-4"
            >
              <div
                className={`w-12 h-12 rounded-full ${getNotificationColor(
                  notification.type
                )} flex items-center justify-center flex-shrink-0`}
              >
                {getNotificationIcon(notification.type)}
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-start justify-between gap-2 mb-1">
                  <h3 className="font-medium text-gray-900">{notification.title}</h3>
                  <span className="text-xs text-gray-500 whitespace-nowrap">
                    {notification.time}
                  </span>
                </div>
                <p className="text-sm text-gray-600 line-clamp-2">{notification.message}</p>
              </div>
              {!notification.read && (
                <div className="w-2 h-2 bg-[var(--alert-orange)] rounded-full flex-shrink-0 mt-2"></div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Other Notifications */}
      <div className="bg-white">
        {otherNotifications.map((notification, index) => (
          <div
            key={notification.id}
            className={`px-4 py-4 hover:bg-gray-50 cursor-pointer flex gap-4 ${
              index !== otherNotifications.length - 1 ? 'border-b border-gray-100' : ''
            }`}
          >
            <div
              className={`w-12 h-12 rounded-full ${getNotificationColor(
                notification.type
              )} flex items-center justify-center flex-shrink-0`}
            >
              {getNotificationIcon(notification.type)}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-start justify-between gap-2 mb-1">
                <h3
                  className={`font-medium ${
                    notification.read ? 'text-gray-600' : 'text-gray-900'
                  }`}
                >
                  {notification.title}
                </h3>
                <span className="text-xs text-gray-500 whitespace-nowrap">
                  {notification.time}
                </span>
              </div>
              <p className="text-sm text-gray-600 line-clamp-2">{notification.message}</p>
            </div>
            {!notification.read && (
              <div className="w-2 h-2 bg-[var(--green-primary)] rounded-full flex-shrink-0 mt-2"></div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}