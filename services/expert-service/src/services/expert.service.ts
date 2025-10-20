import { FilterQuery, SortOrder, Types } from 'mongoose';
import Expert, { IExpert, IExpertReview } from '../models/expert.model';

export interface ListExpertsParams {
  specialty?: string | string[];
  language?: string | string[];
  verified?: string;
  tags?: string | string[];
  minExperience?: string;
  search?: string;
  isHighlighted?: string;
  limit?: string;
  offset?: string;
  sort?: string;
  latitude?: string;
  longitude?: string;
  radiusKm?: string;
}

export interface ReviewPayload {
  reviewerId?: string;
  reviewerName: string;
  rating: number;
  comment?: string;
  strengths?: string[];
  improvements?: string[];
  verifiedConsultation?: boolean;
}

export interface ListExpertsResult {
  data: IExpert[];
  total: number;
  limit: number;
  offset: number;
}

const toBoolean = (value?: string): boolean | undefined => {
  if (value === undefined) return undefined;
  if (value === 'true') return true;
  if (value === 'false') return false;
  return undefined;
};

const splitValues = (value?: string | string[]): string[] | undefined => {
  if (!value) return undefined;
  if (Array.isArray(value)) {
    return value
      .map(entry => entry.trim())
      .filter(Boolean);
  }
  return value
    .split(',')
    .map(entry => entry.trim())
    .filter(Boolean);
};

const parseSort = (sort?: string): Record<string, SortOrder> => {
  if (!sort) {
    return { 'rating.average': -1 as SortOrder, createdAt: -1 as SortOrder };
  }

  return sort.split(',').reduce<Record<string, SortOrder>>((acc, token) => {
    const trimmed = token.trim();
    if (!trimmed) return acc;
    if (trimmed.startsWith('-')) {
      acc[trimmed.substring(1)] = -1;
    } else if (trimmed.startsWith('+')) {
      acc[trimmed.substring(1)] = 1;
    } else {
      acc[trimmed] = 1;
    }
    return acc;
  }, {});
};

const applyRatingMetrics = (expert: IExpert) => {
  const distribution = {
    fiveStars: 0,
    fourStars: 0,
    threeStars: 0,
    twoStars: 0,
    oneStar: 0
  };

  let totalScore = 0;

  expert.reviews.forEach(review => {
    totalScore += review.rating;
    switch (review.rating) {
      case 5:
        distribution.fiveStars += 1;
        break;
      case 4:
        distribution.fourStars += 1;
        break;
      case 3:
        distribution.threeStars += 1;
        break;
      case 2:
        distribution.twoStars += 1;
        break;
      default:
        distribution.oneStar += 1;
    }
  });

  const totalReviews = expert.reviews.length;
  expert.rating.totalReviews = totalReviews;
  expert.rating.average =
    totalReviews === 0 ? 0 : parseFloat((totalScore / totalReviews).toFixed(2));
  expert.rating.distribution = distribution;
};

const buildGeoFilter = (params: ListExpertsParams) => {
  if (!params.latitude || !params.longitude || !params.radiusKm) {
    return undefined;
  }

  const latitude = Number(params.latitude);
  const longitude = Number(params.longitude);
  const radiusKm = Number(params.radiusKm);

  if (
    Number.isNaN(latitude) ||
    Number.isNaN(longitude) ||
    Number.isNaN(radiusKm)
  ) {
    return undefined;
  }

  return {
    location: {
      coordinates: {
        $geoWithin: {
          $centerSphere: [[longitude, latitude], radiusKm / 6378.1]
        }
      }
    }
  } as FilterQuery<IExpert>;
};

export const createExpert = async (data: Partial<IExpert>) => {
  return Expert.create(data);
};

export const listExperts = async (
  params: ListExpertsParams
): Promise<ListExpertsResult> => {
  const filter: FilterQuery<IExpert> = {};

  const specialties = splitValues(params.specialty);
  if (specialties && specialties.length > 0) {
    filter.specialties = { $in: specialties };
  }

  const languages = splitValues(params.language);
  if (languages && languages.length > 0) {
    filter.languages = { $in: languages };
  }

  const tags = splitValues(params.tags);
  if (tags && tags.length > 0) {
    filter.tags = { $in: tags };
  }

  const verified = toBoolean(params.verified);
  if (verified !== undefined) {
    filter.verified = verified;
  }

  const minExperience = params.minExperience
    ? Number(params.minExperience)
    : undefined;
  if (minExperience !== undefined && !Number.isNaN(minExperience)) {
    filter.yearsOfExperience = { $gte: minExperience };
  }

  if (params.search) {
    filter.$text = { $search: params.search };
  }

  const geoFilter = buildGeoFilter(params);
  if (geoFilter) {
    Object.assign(filter, geoFilter);
  }

  const limit = Math.min(Math.max(Number(params.limit) || 20, 1), 100);
  const offset = Math.max(Number(params.offset) || 0, 0);

  const [total, data] = await Promise.all([
    Expert.countDocuments(filter),
    Expert.find(filter)
      .sort(parseSort(params.sort))
      .skip(offset)
      .limit(limit)
  ]);

  return {
    data,
    total,
    limit,
    offset
  };
};

export const getExpertById = async (id: string) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Expert.findById(id);
};

export const updateExpert = async (id: string, data: Partial<IExpert>) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Expert.findByIdAndUpdate(id, data, {
    new: true,
    runValidators: true
  });
};

export const deleteExpert = async (id: string) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Expert.findByIdAndDelete(id);
};

export const listSpecialties = async () => {
  return Expert.aggregate<{ specialty: string; count: number }>([
    { $unwind: '$specialties' },
    {
      $group: {
        _id: '$specialties',
        count: { $sum: 1 }
      }
    },
    {
      $project: {
        _id: 0,
        specialty: '$_id',
        count: 1
      }
    },
    { $sort: { count: -1, specialty: 1 } }
  ]);
};

export const addReview = async (
  expertId: string,
  payload: ReviewPayload
): Promise<IExpert | null> => {
  if (!Types.ObjectId.isValid(expertId)) {
    return null;
  }

  const expert = await Expert.findById(expertId);
  if (!expert) {
    return null;
  }

  const review: IExpertReview = {
    _id: new Types.ObjectId(),
    reviewerId: payload.reviewerId
      ? new Types.ObjectId(payload.reviewerId)
      : undefined,
    reviewerName: payload.reviewerName,
    rating: payload.rating,
    comment: payload.comment,
    strengths: payload.strengths ?? [],
    improvements: payload.improvements ?? [],
    verifiedConsultation: payload.verifiedConsultation ?? false,
    createdAt: new Date(),
    updatedAt: new Date()
  };

  expert.reviews.push(review);
  applyRatingMetrics(expert);

  await expert.save();
  return expert;
};

export const listReviews = async (expertId: string) => {
  if (!Types.ObjectId.isValid(expertId)) {
    return null;
  }
  const expert = await Expert.findById(expertId, { reviews: 1 });
  if (!expert) {
    return null;
  }
  return expert.reviews;
};

export const removeReview = async (
  expertId: string,
  reviewId: string
): Promise<IExpert | null> => {
  if (!Types.ObjectId.isValid(expertId) || !Types.ObjectId.isValid(reviewId)) {
    return null;
  }

  const expert = await Expert.findById(expertId);
  if (!expert) {
    return null;
  }

  const initialCount = expert.reviews.length;
  expert.reviews = expert.reviews.filter(
    review => review._id.toString() !== reviewId
  ) as unknown as IExpertReview[];

  if (expert.reviews.length === initialCount) {
    return null;
  }

  applyRatingMetrics(expert);
  await expert.save();
  return expert;
};
