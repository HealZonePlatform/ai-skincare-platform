'use client';

import { LazyLoadImage } from 'react-lazy-load-image-component';
import 'react-lazy-load-image-component/src/effects/blur.css';

interface ImageWithLazyLoadProps {
  src: string;
  alt: string;
  className?: string;
  width?: number;
  height?: number;
  priority?: boolean;
}

const ImageWithLazyLoad = ({ 
  src, 
  alt, 
  className = '',
  width,
  height,
  priority = false
}: ImageWithLazyLoadProps) => {
  return (
    <LazyLoadImage
      src={src}
      alt={alt}
      className={className}
      width={width}
      height={height}
      effect="blur"
      threshold={100}
      placeholder={
        <div className={`bg-gray-200 border-2 border-dashed border-gray-400 rounded-xl flex items-center justify-center ${className}`}>
          <span className="text-gray-500">Loading...</span>
        </div>
      }
      visibleByDefault={priority}
      wrapperClassName="w-full h-full"
    />
  );
};

export default ImageWithLazyLoad;