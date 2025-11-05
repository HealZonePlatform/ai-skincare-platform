type Primitive = string | number | boolean | null | undefined;

const isPrimitiveArray = (value: unknown): value is Primitive[] =>
  Array.isArray(value) && value.every((item) => typeof item !== 'object');

export const buildQueryString = (params: Record<string, unknown>) => {
  const searchParams = new URLSearchParams();

  Object.entries(params).forEach(([key, value]) => {
    if (value === undefined || value === null) {
      return;
    }

    if (typeof value === 'string' && value.trim() === '') {
      return;
    }

    if (isPrimitiveArray(value)) {
      value
        .filter((item) => item !== undefined && item !== null && String(item).trim() !== '')
        .forEach((item) => {
          searchParams.append(key, String(item));
        });
      return;
    }

    if (typeof value === 'object') {
      Object.entries(value as Record<string, Primitive>).forEach(([nestedKey, nestedValue]) => {
        if (nestedValue === undefined || nestedValue === null) {
          return;
        }
        searchParams.append(`${key}[${nestedKey}]`, String(nestedValue));
      });
      return;
    }

    searchParams.append(key, String(value));
  });

  const queryString = searchParams.toString();
  return queryString ? `?${queryString}` : '';
};
