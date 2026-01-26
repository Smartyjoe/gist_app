import { X } from 'lucide-react';

interface TranslationModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentLanguage: string;
  onSelectLanguage: (language: string) => void;
}

const languages = [
  { code: 'en', name: 'English', native: 'English' },
  { code: 'yo', name: 'Yoruba', native: 'Yorùbá' },
  { code: 'ha', name: 'Hausa', native: 'Hausa' },
  { code: 'ig', name: 'Igbo', native: 'Igbo' },
];

export function TranslationModal({
  isOpen,
  onClose,
  currentLanguage,
  onSelectLanguage,
}: TranslationModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-end justify-center z-50">
      <div className="bg-white rounded-t-3xl w-full max-w-md animate-slide-up">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-[var(--grey-soft)]">
          <h3 className="text-lg">Translate to</h3>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-gray-100 flex items-center justify-center"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Language options */}
        <div className="p-4 space-y-2">
          {languages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => {
                onSelectLanguage(lang.code);
                onClose();
              }}
              className={`w-full p-4 rounded-xl text-left transition-colors ${
                currentLanguage === lang.code
                  ? 'bg-[var(--green-primary)] text-white'
                  : 'bg-gray-50 hover:bg-gray-100'
              }`}
            >
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">{lang.name}</p>
                  <p className={`text-sm ${currentLanguage === lang.code ? 'text-white/80' : 'text-gray-500'}`}>
                    {lang.native}
                  </p>
                </div>
                {currentLanguage === lang.code && (
                  <div className="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center">
                    <span className="text-white">✓</span>
                  </div>
                )}
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
