// product.model.ts
import mongoose, { Schema, Document, Types } from 'mongoose';

// Interface definition
export interface IProduct extends Document {
  _id: Types.ObjectId;
  name: string;
  description: string;
  brand: string;
  category: string;
  subCategory?: string;
  skinTypes: string[];
  skinConcerns: string[];
  ingredients: IIngredient[];
  price: IPrice;
  images: string[];
  ratings: IRating;
  availability: IAvailability;
  specifications: ISpecification[];
  usage: IUsage;
  warnings?: string[];
  certifications?: string[];
  tags: string[];
  isActive: boolean;
  isRecommended: boolean;
  expertReviews?: IExpertReview[];
  userReviews?: Types.ObjectId[]; // Reference to Review collection
  createdAt: Date;
  updatedAt: Date;
}

interface IIngredient {
  name: string;
  percentage?: number;
  function: string;
  isActive: boolean;
  benefits?: string[];
  concerns?: string[];
}

interface IPrice {
  currency: string;
  amount: number;
  discountedAmount?: number;
  discountPercentage?: number;
}

interface IRating {
  average: number;
  totalReviews: number;
  distribution: {
    fiveStars: number;
    fourStars: number;
    threeStars: number;
    twoStars: number;
    oneStar: number;
  };
}

interface IAvailability {
  inStock: boolean;
  quantity: number;
  lowStockThreshold: number;
  restockDate?: Date;
}

interface ISpecification {
  name: string;
  value: string;
  unit?: string;
}

interface IUsage {
  instructions: string[];
  frequency: string;
  duration?: string;
  timeOfDay: string[];
  applicationOrder?: number;
}

interface IExpertReview {
  expertId: Types.ObjectId; // Reference to Expert collection
  rating: number;
  review: string;
  pros?: string[];
  cons?: string[];
  recommendation: string;
  reviewDate: Date;
  isVerified: boolean;
}

// Mongoose schema definition
const IngredientSchema = new Schema<IIngredient>({
  name: {
    type: String,
    required: true,
    trim: true
  },
  percentage: {
    type: Number,
    min: 0,
    max: 100
  },
  function: {
    type: String,
    required: true,
    enum: ['cleanser', 'moisturizer', 'active', 'preservative', 'fragrance', 'stabilizer', 'other']
  },
  isActive: {
    type: Boolean,
    default: false
  },
  benefits: [{
    type: String,
    trim: true
  }],
  concerns: [{
    type: String,
    trim: true
  }]
}, { _id: false });

const PriceSchema = new Schema<IPrice>({
  currency: {
    type: String,
    required: true,
    default: 'USD',
    enum: ['USD', 'VND', 'EUR', 'GBP']
  },
  amount: {
    type: Number,
    required: true,
    min: 0
  },
  discountedAmount: {
    type: Number,
    min: 0,
    validate: {
      validator: function(this: IPrice, value: number) {
        return !value || value < this.amount;
      },
      message: 'Discounted amount must be less than original amount'
    }
  },
  discountPercentage: {
    type: Number,
    min: 0,
    max: 100
  }
}, { _id: false });

const RatingSchema = new Schema<IRating>({
  average: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  totalReviews: {
    type: Number,
    default: 0,
    min: 0
  },
  distribution: {
    fiveStars: { type: Number, default: 0, min: 0 },
    fourStars: { type: Number, default: 0, min: 0 },
    threeStars: { type: Number, default: 0, min: 0 },
    twoStars: { type: Number, default: 0, min: 0 },
    oneStar: { type: Number, default: 0, min: 0 }
  }
}, { _id: false });

const AvailabilitySchema = new Schema<IAvailability>({
  inStock: {
    type: Boolean,
    default: true
  },
  quantity: {
    type: Number,
    required: true,
    min: 0
  },
  lowStockThreshold: {
    type: Number,
    default: 10,
    min: 0
  },
  restockDate: {
    type: Date
  }
}, { _id: false });

const SpecificationSchema = new Schema<ISpecification>({
  name: {
    type: String,
    required: true,
    trim: true
  },
  value: {
    type: String,
    required: true,
    trim: true
  },
  unit: {
    type: String,
    trim: true
  }
}, { _id: false });

const UsageSchema = new Schema<IUsage>({
  instructions: [{
    type: String,
    required: true,
    trim: true
  }],
  frequency: {
    type: String,
    required: true,
    enum: ['daily', 'twice-daily', 'every-other-day', 'weekly', 'as-needed']
  },
  duration: {
    type: String,
    trim: true
  },
  timeOfDay: [{
    type: String,
    enum: ['morning', 'afternoon', 'evening', 'night']
  }],
  applicationOrder: {
    type: Number,
    min: 1,
    max: 10
  }
}, { _id: false });

const ExpertReviewSchema = new Schema<IExpertReview>({
  expertId: {
    type: Schema.Types.ObjectId,
    ref: 'Expert',
    required: true
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  },
  review: {
    type: String,
    required: true,
    trim: true,
    maxLength: 2000
  },
  pros: [{
    type: String,
    trim: true
  }],
  cons: [{
    type: String,
    trim: true
  }],
  recommendation: {
    type: String,
    required: true,
    enum: ['highly-recommended', 'recommended', 'conditional', 'not-recommended']
  },
  reviewDate: {
    type: Date,
    default: Date.now
  },
  isVerified: {
    type: Boolean,
    default: false
  }
}, { _id: false });

// Main Product schema
const ProductSchema = new Schema<IProduct>({
  name: {
    type: String,
    required: true,
    trim: true,
    maxLength: 200,
    index: true
  },
  description: {
    type: String,
    required: true,
    trim: true,
    maxLength: 2000
  },
  brand: {
    type: String,
    required: true,
    trim: true,
    index: true
  },
  category: {
    type: String,
    required: true,
    enum: [
      'cleanser',
      'moisturizer', 
      'serum',
      'treatment',
      'sunscreen',
      'mask',
      'toner',
      'eye-care',
      'exfoliant',
      'oil',
      'tools',
      'supplements'
    ],
    index: true
  },
  subCategory: {
    type: String,
    trim: true
  },
  skinTypes: [{
    type: String,
    enum: ['oily', 'dry', 'combination', 'sensitive', 'normal', 'mature'],
    required: true
  }],
  skinConcerns: [{
    type: String,
    enum: [
      'acne',
      'aging',
      'hyperpigmentation',
      'dryness',
      'sensitivity',
      'oiliness',
      'pores',
      'dark-spots',
      'wrinkles',
      'dullness',
      'redness',
      'blackheads'
    ]
  }],
  ingredients: [IngredientSchema],
  price: {
    type: PriceSchema,
    required: true
  },
  images: [{
    type: String,
    required: true,
    validate: {
      validator: function(url: string) {
        return /^https?:\/\/.+\.(jpg|jpeg|png|webp|gif)$/i.test(url);
      },
      message: 'Invalid image URL format'
    }
  }],
  ratings: {
    type: RatingSchema,
    default: () => ({
      average: 0,
      totalReviews: 0,
      distribution: {
        fiveStars: 0,
        fourStars: 0,
        threeStars: 0,
        twoStars: 0,
        oneStar: 0
      }
    })
  },
  availability: {
    type: AvailabilitySchema,
    required: true
  },
  specifications: [SpecificationSchema],
  usage: {
    type: UsageSchema,
    required: true
  },
  warnings: [{
    type: String,
    trim: true
  }],
  certifications: [{
    type: String,
    trim: true,
    enum: ['organic', 'cruelty-free', 'vegan', 'dermatologist-tested', 'hypoallergenic', 'non-comedogenic']
  }],
  tags: [{
    type: String,
    trim: true,
    lowercase: true
  }],
  isActive: {
    type: Boolean,
    default: true,
    index: true
  },
  isRecommended: {
    type: Boolean,
    default: false,
    index: true
  },
  expertReviews: [ExpertReviewSchema],
  userReviews: [{
    type: Schema.Types.ObjectId,
    ref: 'Review'
  }]
}, {
  timestamps: true, // Automatically adds createdAt and updatedAt
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes for better query performance
ProductSchema.index({ name: 'text', description: 'text', brand: 'text' });
ProductSchema.index({ category: 1, subCategory: 1 });
ProductSchema.index({ skinTypes: 1 });
ProductSchema.index({ skinConcerns: 1 });
ProductSchema.index({ 'price.amount': 1 });
ProductSchema.index({ 'ratings.average': -1 });
ProductSchema.index({ isActive: 1, isRecommended: 1 });
ProductSchema.index({ createdAt: -1 });

// Virtual for discounted price calculation
ProductSchema.virtual('effectivePrice').get(function() {
  return this.price.discountedAmount || this.price.amount;
});

// Virtual for stock status
ProductSchema.virtual('stockStatus').get(function() {
  if (!this.availability.inStock) return 'out-of-stock';
  if (this.availability.quantity <= this.availability.lowStockThreshold) return 'low-stock';
  return 'in-stock';
});

// Pre-save middleware to calculate discount percentage
ProductSchema.pre('save', function(next) {
  if (this.price.discountedAmount && this.price.amount) {
    this.price.discountPercentage = Math.round(
      ((this.price.amount - this.price.discountedAmount) / this.price.amount) * 100
    );
  }
  next();
});

// Static method to find products by skin type
ProductSchema.statics.findBySkinType = function(skinType: string) {
  return this.find({ 
    skinTypes: skinType, 
    isActive: true 
  }).sort({ 'ratings.average': -1 });
};

// Static method to find products by skin concerns
ProductSchema.statics.findBySkinConcerns = function(concerns: string[]) {
  return this.find({ 
    skinConcerns: { $in: concerns }, 
    isActive: true 
  }).sort({ 'ratings.average': -1 });
};

// Instance method to check if product is suitable for skin type
ProductSchema.methods.isSuitableFor = function(skinType: string, concerns?: string[]) {
  const skinTypeMatch = this.skinTypes.includes(skinType);
  if (!concerns || concerns.length === 0) return skinTypeMatch;
  
  const concernMatch = concerns.some(concern => this.skinConcerns.includes(concern));
  return skinTypeMatch && concernMatch;
};

// Create and export model
const Product = mongoose.model<IProduct>('Product', ProductSchema);

export default Product;
