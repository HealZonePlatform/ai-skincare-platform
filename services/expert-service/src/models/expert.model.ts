import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IExpertReview {
  _id: Types.ObjectId;
  reviewerId?: Types.ObjectId;
  reviewerName: string;
  rating: number;
  comment?: string;
  strengths?: string[];
  improvements?: string[];
  createdAt: Date;
  updatedAt: Date;
  verifiedConsultation: boolean;
}

export interface IConsultationOption {
  mode: 'online' | 'in-person' | 'hybrid';
  durationMinutes: number;
  fee: number;
  currency: string;
  notes?: string;
}

export interface IAvailabilitySlot {
  dayOfWeek: number;
  startTime: string;
  endTime: string;
  timezone: string;
}

export interface ICertification {
  title: string;
  issuer: string;
  issuedAt: Date;
  expiresAt?: Date;
  credentialId?: string;
}

export interface IEducation {
  institution: string;
  field: string;
  degree?: string;
  startYear?: number;
  endYear?: number;
}

export interface IExpert extends Document {
  _id: Types.ObjectId;
  name: string;
  slug: string;
  about: string;
  specialties: string[];
  languages: string[];
  consultationOptions: IConsultationOption[];
  availability: IAvailabilitySlot[];
  rating: {
    average: number;
    totalReviews: number;
    distribution: {
      fiveStars: number;
      fourStars: number;
      threeStars: number;
      twoStars: number;
      oneStar: number;
    };
  };
  verified: boolean;
  avatar?: string;
  yearsOfExperience: number;
  certifications: ICertification[];
  education: IEducation[];
  socialLinks: {
    platform: string;
    url: string;
  }[];
  consultationCount: number;
  tags: string[];
  location?: {
    country?: string;
    city?: string;
    coordinates?: {
      type: 'Point';
      coordinates: [number, number];
    };
  };
  reviews: IExpertReview[];
  createdAt: Date;
  updatedAt: Date;
}

const ReviewSchema = new Schema<IExpertReview>(
  {
    reviewerId: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    reviewerName: {
      type: String,
      required: true,
      trim: true
    },
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5
    },
    comment: {
      type: String,
      trim: true
    },
    strengths: [
      {
        type: String,
        trim: true
      }
    ],
    improvements: [
      {
        type: String,
        trim: true
      }
    ],
    verifiedConsultation: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true
  }
);

const ConsultationOptionSchema = new Schema<IConsultationOption>(
  {
    mode: {
      type: String,
      enum: ['online', 'in-person', 'hybrid'],
      default: 'online'
    },
    durationMinutes: {
      type: Number,
      min: 15,
      max: 240,
      required: true
    },
    fee: {
      type: Number,
      min: 0,
      required: true
    },
    currency: {
      type: String,
      default: 'USD'
    },
    notes: {
      type: String,
      trim: true
    }
  },
  {
    _id: false
  }
);

const AvailabilitySlotSchema = new Schema<IAvailabilitySlot>(
  {
    dayOfWeek: {
      type: Number,
      min: 0,
      max: 6,
      required: true
    },
    startTime: {
      type: String,
      required: true,
      match: /^([01]\d|2[0-3]):[0-5]\d$/
    },
    endTime: {
      type: String,
      required: true,
      match: /^([01]\d|2[0-3]):[0-5]\d$/
    },
    timezone: {
      type: String,
      required: true
    }
  },
  {
    _id: false
  }
);

const CertificationSchema = new Schema<ICertification>(
  {
    title: {
      type: String,
      required: true,
      trim: true
    },
    issuer: {
      type: String,
      required: true,
      trim: true
    },
    issuedAt: {
      type: Date,
      required: true
    },
    expiresAt: {
      type: Date
    },
    credentialId: {
      type: String,
      trim: true
    }
  },
  {
    _id: false
  }
);

const EducationSchema = new Schema<IEducation>(
  {
    institution: {
      type: String,
      required: true,
      trim: true
    },
    field: {
      type: String,
      required: true,
      trim: true
    },
    degree: {
      type: String,
      trim: true
    },
    startYear: {
      type: Number,
      min: 1950,
      max: new Date().getFullYear()
    },
    endYear: {
      type: Number,
      min: 1950,
      max: new Date().getFullYear() + 10
    }
  },
  {
    _id: false
  }
);

const ExpertSchema = new Schema<IExpert>(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },
    slug: {
      type: String,
      unique: true,
      trim: true
    },
    about: {
      type: String,
      trim: true,
      default: ''
    },
    specialties: {
      type: [String],
      required: true,
      index: true
    },
    languages: {
      type: [String],
      default: ['en'],
      index: true
    },
    consultationOptions: {
      type: [ConsultationOptionSchema],
      default: []
    },
    availability: {
      type: [AvailabilitySlotSchema],
      default: []
    },
    rating: {
      average: { type: Number, default: 0 },
      totalReviews: { type: Number, default: 0 },
      distribution: {
        fiveStars: { type: Number, default: 0 },
        fourStars: { type: Number, default: 0 },
        threeStars: { type: Number, default: 0 },
        twoStars: { type: Number, default: 0 },
        oneStar: { type: Number, default: 0 }
      }
    },
    verified: {
      type: Boolean,
      default: false,
      index: true
    },
    avatar: {
      type: String,
      trim: true
    },
    yearsOfExperience: {
      type: Number,
      min: 0,
      max: 60,
      default: 0
    },
    certifications: {
      type: [CertificationSchema],
      default: []
    },
    education: {
      type: [EducationSchema],
      default: []
    },
    socialLinks: [
      {
        platform: {
          type: String,
          trim: true
        },
        url: {
          type: String,
          trim: true
        }
      }
    ],
    consultationCount: {
      type: Number,
      default: 0
    },
    tags: {
      type: [String],
      default: [],
      lowercase: true,
      index: true
    },
    location: {
      country: {
        type: String,
        trim: true
      },
      city: {
        type: String,
        trim: true
      },
      coordinates: {
        type: {
          type: String,
          enum: ['Point'],
          default: 'Point'
        },
        coordinates: {
          type: [Number],
          default: undefined
        }
      }
    },
    reviews: {
      type: [ReviewSchema],
      default: []
    }
  },
  {
    timestamps: true
  }
);

ExpertSchema.index({ name: 'text', about: 'text', specialties: 'text' });
ExpertSchema.index({ 'location.coordinates': '2dsphere' });
ExpertSchema.index({ 'rating.average': -1 });

ExpertSchema.pre('save', function (next) {
  if (!this.slug) {
    this.slug = this.name
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }
  next();
});

const Expert = mongoose.model<IExpert>('Expert', ExpertSchema);

export default Expert;
export { Expert };
