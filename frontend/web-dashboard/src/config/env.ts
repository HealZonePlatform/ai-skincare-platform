const stripTrailingSlash = (value: string) => value.replace(/\/+$/, '');
const stripLeadingSlash = (value: string) => value.replace(/^\/+/, '');

const apiGatewayUrl = stripTrailingSlash(
  process.env.NEXT_PUBLIC_API_GATEWAY_URL ?? 'http://localhost:4000'
);

const apiBasePath = stripLeadingSlash(process.env.NEXT_PUBLIC_API_BASE_PATH ?? '/api/v1');
const authPath = stripLeadingSlash(
  process.env.NEXT_PUBLIC_AUTH_PATH ?? `${apiBasePath}/auth`
);

export const API_BASE_URL = `${apiGatewayUrl}/${apiBasePath}`;
export const AUTH_BASE_URL =
  process.env.NEXT_PUBLIC_AUTH_BASE_URL ?? `${apiGatewayUrl}/${authPath}`;

export const REQUEST_TIMEOUT_MS = Number.parseInt(
  process.env.NEXT_PUBLIC_REQUEST_TIMEOUT_MS ?? '15000',
  10
);
