'use client';

const PlaceholderImage = ({ width = 300, height = 200, text = "Demo Image" }) => {
  return (
    <div 
      className="bg-gradient-to-br from-primary-100 to-secondary-100 border-2 border-dashed border-gray-300 rounded-xl flex items-center justify-center"
      style={{ width: `${width}px`, height: `${height}px` }}
    >
      <div className="text-center">
        <div className="w-12 h-12 bg-primary-600 rounded-full flex items-center justify-center mx-auto mb-2">
          <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>
        <p className="text-gray-700 font-medium">{text}</p>
        <p className="text-gray-500 text-sm mt-1">{width}×{height}</p>
      </div>
    </div>
  );
};

export default PlaceholderImage;