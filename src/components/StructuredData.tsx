import React from 'react';

export default function StructuredData() {
  const websiteData = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: "Horizon Skincare AI",
    url: "https://horizonskincare.online/",
    potentialAction: {
      "@type": "SearchAction",
      target: "https://horizonskincare.online/?q={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  };

  const organizationData = {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: "Horizon Skincare",
    url: "https://horizonskincare.online/",
    logo: "https://horizonskincare.online/android-chrome-192x192.png",
    sameAs: []
  };

  // Product schema - Example product data
  const productData = {
    "@context": "https://schema.org/",
    "@type": "Product",
    name: "Horizon Skincare AI Premium Set",
    image: [
      "https://horizonskincare.online/product-1.jpg",
      "https://horizonskincare.online/product-2.jpg"
    ],
    description: "Bộ sản phẩm chăm sóc da cao cấp với công nghệ AI phân tích da chuyên sâu",
    brand: {
      "@type": "Brand",
      name: "Horizon Skincare"
    },
    aggregateRating: {
      "@type": "AggregateRating",
      ratingValue: "4.8",
      reviewCount: "120",
      bestRating: "5",
      worstRating: "1"
    },
    offers: {
      "@type": "Offer",
      url: "https://horizonskincare.online/products/premium-set",
      priceCurrency: "VND",
      price: "1990000",
      priceValidUntil: "2025-12-31",
      availability: "https://schema.org/InStock",
      seller: {
        "@type": "Organization",
        name: "Horizon Skincare"
      }
    }
  };

  // Review schema - Example review data
  const reviewData = {
    "@context": "https://schema.org/",
    "@type": "Review",
    reviewBody: "Sản phẩm tuyệt vời! Da tôi đã cải thiện rõ rệt sau 2 tuần sử dụng. Công nghệ AI phân tích da rất chính xác và hữu ích.",
    datePublished: "2024-10-11",
    reviewRating: {
      "@type": "Rating",
      ratingValue: "5",
      bestRating: "5",
      worstRating: "1"
    },
    author: {
      "@type": "Person",
      name: "Nguyễn Thị Mai"
    },
    itemReviewed: {
      "@type": "Product",
      name: "Horizon Skincare AI Premium Set"
    }
  };

  // BreadcrumbList schema
  const breadcrumbData = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [{
      "@type": "ListItem",
      position: 1,
      name: "Trang chủ",
      item: "https://horizonskincare.online/"
    }, {
      "@type": "ListItem",
      position: 2,
      name: "Sản phẩm",
      item: "https://horizonskincare.online/products"
    }, {
      "@type": "ListItem",
      position: 3,
      name: "Horizon Skincare AI Premium Set",
      item: "https://horizonskincare.online/products/premium-set"
    }]
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteData) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationData) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(productData) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(reviewData) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbData) }}
      />
    </>
  );
}