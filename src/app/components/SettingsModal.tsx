import { useState } from 'react';
import { X, Check, ChevronRight } from 'lucide-react';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const languages = [
  { code: 'en', name: 'English', native: 'English' },
  { code: 'yo', name: 'Yoruba', native: 'Yorùbá' },
  { code: 'ha', name: 'Hausa', native: 'Hausa' },
  { code: 'ig', name: 'Igbo', native: 'Igbo' },
];

const textSizes = [
  { value: 'small', label: 'Small', preview: 'Aa' },
  { value: 'medium', label: 'Medium (Default)', preview: 'Aa' },
  { value: 'large', label: 'Large', preview: 'Aa' },
  { value: 'xlarge', label: 'Extra Large', preview: 'Aa' },
];

export function SettingsModal({ isOpen, onClose }: SettingsModalProps) {
  const [preferredLanguage, setPreferredLanguage] = useState('en');
  const [textSize, setTextSize] = useState('medium');
  const [audioFirstMode, setAudioFirstMode] = useState(false);
  const [emergencyAlerts, setEmergencyAlerts] = useState(true);
  const [locationAlerts, setLocationAlerts] = useState(true);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-end justify-center z-50">
      <div className="bg-white rounded-t-3xl w-full max-w-md h-[90vh] flex flex-col animate-slide-up">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-gray-200 flex-shrink-0">
          <h2 className="text-xl">Settings</h2>
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto">
          {/* Language Settings */}
          <div className="p-4 border-b border-gray-200">
            <h3 className="font-medium text-gray-900 mb-2">Preferred Language</h3>
            <p className="text-sm text-gray-500 mb-4">
              Choose your default language for the app and translations
            </p>
            <div className="space-y-2">
              {languages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => setPreferredLanguage(lang.code)}
                  className={`w-full p-4 rounded-xl border-2 transition-all flex items-center justify-between ${
                    preferredLanguage === lang.code
                      ? 'border-[var(--green-primary)] bg-green-50'
                      : 'border-gray-200 bg-white hover:border-gray-300'
                  }`}
                >
                  <div className="text-left">
                    <p className="font-medium text-gray-900">{lang.name}</p>
                    <p className="text-sm text-gray-500">{lang.native}</p>
                  </div>
                  {preferredLanguage === lang.code && (
                    <div className="w-6 h-6 rounded-full bg-[var(--green-primary)] flex items-center justify-center">
                      <Check className="w-4 h-4 text-white" />
                    </div>
                  )}
                </button>
              ))}
            </div>
          </div>

          {/* Accessibility Settings */}
          <div className="p-4 border-b border-gray-200">
            <h3 className="font-medium text-gray-900 mb-2">Accessibility</h3>
            <p className="text-sm text-gray-500 mb-4">
              Customize the app to meet your needs
            </p>

            {/* Text Size */}
            <div className="mb-4">
              <label className="text-sm text-gray-700 mb-3 block">Text Size</label>
              <div className="grid grid-cols-2 gap-2">
                {textSizes.map((size) => (
                  <button
                    key={size.value}
                    onClick={() => setTextSize(size.value)}
                    className={`p-3 rounded-xl border-2 transition-all ${
                      textSize === size.value
                        ? 'border-[var(--green-primary)] bg-green-50'
                        : 'border-gray-200 bg-white hover:border-gray-300'
                    }`}
                  >
                    <div
                      className={`font-medium mb-1 ${
                        size.value === 'small'
                          ? 'text-sm'
                          : size.value === 'medium'
                          ? 'text-base'
                          : size.value === 'large'
                          ? 'text-lg'
                          : 'text-xl'
                      }`}
                    >
                      {size.preview}
                    </div>
                    <p className="text-xs text-gray-600">{size.label}</p>
                  </button>
                ))}
              </div>
            </div>

            {/* Audio-First Mode */}
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
              <div className="flex-1">
                <p className="font-medium text-gray-900">Audio-First Mode</p>
                <p className="text-sm text-gray-500">Prioritize voice and audio content</p>
              </div>
              <button
                onClick={() => setAudioFirstMode(!audioFirstMode)}
                className={`w-14 h-8 rounded-full transition-colors relative ${
                  audioFirstMode ? 'bg-[var(--green-primary)]' : 'bg-gray-300'
                }`}
              >
                <div
                  className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                    audioFirstMode ? 'translate-x-7' : 'translate-x-1'
                  }`}
                ></div>
              </button>
            </div>
          </div>

          {/* Notification Settings */}
          <div className="p-4 border-b border-gray-200">
            <h3 className="font-medium text-gray-900 mb-2">Notifications</h3>
            <p className="text-sm text-gray-500 mb-4">
              Choose what notifications you want to receive
            </p>

            <div className="space-y-3">
              {/* Emergency Alerts */}
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                <div className="flex-1">
                  <p className="font-medium text-gray-900">Emergency Alerts</p>
                  <p className="text-sm text-gray-500">
                    Critical safety notifications (recommended)
                  </p>
                </div>
                <button
                  onClick={() => setEmergencyAlerts(!emergencyAlerts)}
                  className={`w-14 h-8 rounded-full transition-colors relative ${
                    emergencyAlerts ? 'bg-[var(--green-primary)]' : 'bg-gray-300'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      emergencyAlerts ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  ></div>
                </button>
              </div>

              {/* Location-Based Alerts */}
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                <div className="flex-1">
                  <p className="font-medium text-gray-900">Location-Based Alerts</p>
                  <p className="text-sm text-gray-500">
                    Get notified about nearby reports
                  </p>
                </div>
                <button
                  onClick={() => setLocationAlerts(!locationAlerts)}
                  className={`w-14 h-8 rounded-full transition-colors relative ${
                    locationAlerts ? 'bg-[var(--green-primary)]' : 'bg-gray-300'
                  }`}
                >
                  <div
                    className={`absolute top-1 w-6 h-6 rounded-full bg-white transition-transform ${
                      locationAlerts ? 'translate-x-7' : 'translate-x-1'
                    }`}
                  ></div>
                </button>
              </div>
            </div>
          </div>

          {/* Additional Options */}
          <div className="p-4">
            <h3 className="font-medium text-gray-900 mb-3">More Options</h3>
            <div className="space-y-1">
              <button className="w-full px-4 py-3 flex items-center justify-between hover:bg-gray-50 rounded-xl transition-colors">
                <span className="text-gray-700">Data Usage</span>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
              <button className="w-full px-4 py-3 flex items-center justify-between hover:bg-gray-50 rounded-xl transition-colors">
                <span className="text-gray-700">Storage & Cache</span>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
              <button className="w-full px-4 py-3 flex items-center justify-between hover:bg-gray-50 rounded-xl transition-colors">
                <span className="text-gray-700">Privacy Policy</span>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
              <button className="w-full px-4 py-3 flex items-center justify-between hover:bg-gray-50 rounded-xl transition-colors">
                <span className="text-gray-700">Terms of Service</span>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="p-4 border-t border-gray-200 flex-shrink-0">
          <button
            onClick={onClose}
            className="w-full py-4 bg-[var(--green-primary)] text-white rounded-xl"
          >
            Save Changes
          </button>
        </div>
      </div>
    </div>
  );
}
