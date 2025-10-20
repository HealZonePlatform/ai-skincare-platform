import { FilterQuery, SortOrder, Types } from 'mongoose';
import { IProduct, Product } from '../models/product.model';

export interface ListProductsParams {
  skinType?: string;
  concerns?: string | string[];
  category?: string;
  subCategory?: string;
  verified?: string;
  isActive?: string;
  isRecommended?: string;
  minPrice?: string;
  maxPrice?: string;
  search?: string;
  tags?: string | string[];
  limit?: string;
  offset?: string;
  sort?: string;
}

export interface ListProductsResult {
  data: IProduct[];
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

const applyStringOrArray = (value?: string | string[]): string[] | undefined => {
  if (!value) return undefined;
  if (Array.isArray(value)) {
    return value.filter(Boolean);
  }
  return value
    .split(',')
    .map(part => part.trim())
    .filter(Boolean);
};

const parseSort = (sort?: string): Record<string, SortOrder> => {
  if (!sort) {
    return { createdAt: -1 as SortOrder };
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

export const createProduct = async (data: Partial<IProduct>) => {
  return Product.create(data);
};

export const listProducts = async (
  params: ListProductsParams
): Promise<ListProductsResult> => {
  const filter: FilterQuery<IProduct> = {};

  if (params.skinType) {
    filter.skinTypes = params.skinType;
  }

  const concerns = applyStringOrArray(params.concerns);
  if (concerns && concerns.length > 0) {
    filter.skinConcerns = { $in: concerns };
  }

  if (params.category) {
    filter.category = params.category;
  }

  if (params.subCategory) {
    filter.subCategory = params.subCategory;
  }

  const verified = toBoolean(params.verified);
  if (verified !== undefined) {
    filter.verified = verified;
  }

  const isActive = toBoolean(params.isActive);
  if (isActive !== undefined) {
    filter.isActive = isActive;
  }

  const isRecommended = toBoolean(params.isRecommended);
  if (isRecommended !== undefined) {
    filter.isRecommended = isRecommended;
  }

  const tags = applyStringOrArray(params.tags);
  if (tags && tags.length > 0) {
    filter.tags = { $in: tags };
  }

  if (params.minPrice || params.maxPrice) {
    filter['price.amount'] = {};
    if (params.minPrice) {
      filter['price.amount'].$gte = Number(params.minPrice);
    }
    if (params.maxPrice) {
      filter['price.amount'].$lte = Number(params.maxPrice);
    }
  }

  if (params.search) {
    filter.$text = { $search: params.search };
  }

  const limit = Math.min(Math.max(Number(params.limit) || 20, 1), 100);
  const offset = Math.max(Number(params.offset) || 0, 0);

  const [total, data] = await Promise.all([
    Product.countDocuments(filter),
    Product.find(filter)
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

export const getProductById = async (id: string) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Product.findById(id);
};

export const updateProduct = async (id: string, data: Partial<IProduct>) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Product.findByIdAndUpdate(id, data, {
    new: true,
    runValidators: true
  });
};

export const deleteProduct = async (id: string) => {
  if (!Types.ObjectId.isValid(id)) {
    return null;
  }
  return Product.findByIdAndDelete(id);
};

export const listCategories = async () => {
  return Product.aggregate<{ category: string; subCategory?: string }>([
    {
      $group: {
        _id: {
          category: '$category',
          subCategory: '$subCategory'
        }
      }
    },
    {
      $project: {
        _id: 0,
        category: '$_id.category',
        subCategory: '$_id.subCategory'
      }
    },
    {
      $sort: { category: 1, subCategory: 1 }
    }
  ]);
};
