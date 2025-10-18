'use client';

import Image from 'next/image';
import React from 'react';

interface ImageWithLazyLoadProps {
  src: string;
  alt: string;
  className?: string;
  width?: number;
  height?: number;
  priority?: boolean;
}

const ImageWithLazyLoad: React.FC<ImageWithLazyLoadProps> = ({
  src,
  alt,
  className = '',
  width,
  height,
  priority = false,
}) => {
  return (
    <Image
      src={src}
      alt={alt}
      className={className}
      width={width}
      height={height}
      // Next.js Image component lazy-loads by default; use loading="eager" for priority images
      loading={priority ? 'eager' : 'lazy'}
      placeholder="empty"
    />
  );
};

export default ImageWithLazyLoad;
